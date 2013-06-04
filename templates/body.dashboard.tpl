<script src="/static/js/JSTweener.js"></script>
<script>

// generate by python template for ordered display
var targets = [
% for t in targets:
    {{!t}} ,
% end
]

// generate by js for quick search
var targets_dict = {};
for (var i = 0; i < targets.length; i++) {
    targets_dict[targets[i].path] = targets[i];
}

const SVG = "http://www.w3.org/2000/svg";
const XLINK = "http://www.w3.org/1999/xlink";

const normal_style = 'opacity:0.8; fill: skyblue'; // #990000
const abnormal_style = 'opacity:0.8; fill: #990000';

var bWidth = document.getElementsByTagName("body")[0].clientWidth;
var bHeight = document.getElementsByTagName("body")[0].clientHeight;

var rootHeight = document.defaultView.innerHeight;
var rootWidth = document.defaultView.innerWidth;

var margin = 120;
var radius = 40;
var circles = [];

var focusedCircle;
var bindedCircle;

var messages = [];
var messages_cnt = 0;

var _ = function(name) {
    return defAttr(document.getElementById(name));
}

var C = function(type) {
    return defAttr(document.createElementNS(SVG, "circle"));
}

var defAttr = function(obj) {
    if (obj.definedAttr) return obj;
    obj.definedAttr = true;

    var xywh = ['x', 'y', 'cx', 'cy', 'r', 'width', 'height', 'style'];

    for (var index in xywh) {
        var i = xywh[index];
        obj.__defineGetter__(i, 
                (function(attrName) {
                 return function() { 
                     return this.getAttribute(attrName);
                 }
                 })(i)
            );
        obj.__defineSetter__(i, 
                (function(attrName) {
                     return function(val) { 
                         this.setAttribute(attrName, val);
                         return this.getAttribute(attrName);
                     }
                 })(i)
            );
    }
    return obj;
}

var n16 = function(num) {
    var str = (parseInt(num, 10)).toString(16);
    return str.length == 2 ? str : '0' + str;
}

var randomColor = function() {
    var r = n16(Math.random() * 64 + 127);
    var g = n16(Math.random() * 64 + 127);
    var b = n16(Math.random() * 64 + 127);
    return '#' + r + g + b;
};

function activateCircle(circle) {
    var target = targets_dict[circle.id];
    setInterval(function() {
        var url = '/metric_value/' + circle.id;
        $.get(url, function(metric_value){
            target['curr'] = metric_value;
            messages.push({'name' : circle.id, 'value' : metric_value});
            if(focusedCircle) showTargetInfo();
            if ( metric_value < target.min || metric_value > target.max) {
                bigBang(circle);
            }
        }, 'json');
    }, parseInt(Math.random() * 1000) + 2000);
}

function createSpan(text, left, top) {
    var el = document.createElement('span');
    el.innerHTML = text;
    el.style.position = 'absolute';
    el.style.left = left;
    el.style.top = top;
    el.className = 'alpha5 desc';
    el.style.fontFamily = 'times';
    document.body.appendChild(el);
}

function bigBang(circle) {
    JSTweener.addTween(circle, {
        time: 0.2,
        r: radius * 1.5,
        onComplete: function() {
            JSTweener.addTween(circle, {
                time:2,
                r: radius
            });
        }
    });
}

function showTargetInfo() {
    var target = targets_dict[focusedCircle.id];
    $('#targetinfo_desc').html(target.desc);
    $('#targetinfo_path').html(target.path);
    $('#targetinfo_max').html(target.max);
    $('#targetinfo_min').html(target.min);
    $('#targetinfo_curr').html(target.curr);
}

function clearTargetInfo() {
    $('#targetinfo_desc').html('');
    $('#targetinfo_path').html('');
    $('#targetinfo_max').html('');
    $('#targetinfo_min').html('');
    $('#targetinfo_curr').html('');
}

function createMessage() {
    var metric = messages.shift();
    if (metric == undefined) return null;
    var el = document.createElement('div');
    var target = targets_dict[metric.name];
    if(metric.value > target.min && metric.value < target.max) {
        el.className = 'message';
    } else if (metric.value == target.min || metric.value == target.max) {
        el.className = 'message warning';
    } else {
        el.className = 'message critical';
    }
    el.innerHTML = metric.name + ' ' + metric.value;
    el.style.fontFamily = 'times';
    return el;
}

function pushMessage() {
    var message = createMessage();
    if(!message) return;
    $('#messages')[0].appendChild(message);
    if($('.message').length > 7) {
        popMessage();
    }
}

function popMessage() {
    var fc = $('#messages')[0].firstChild;
    fc.parentNode.removeChild(fc);
}

function mouseOverHandler(e) {
    var circle = e.target;
    focusedCircle = circle;
    showTargetInfo();
}

function mouseOutHandler(e) {
    var circle = e.target;
    if(bindedCircle) {
        focusedCircle = bindedCircle;
    } else {
        focusedCircle = null;
        clearTargetInfo();
    }
}

function mouseDownHandler(e) {
    var circle = e.target;
    if(bindedCircle && bindedCircle.id == circle.id) {
        bindedCircle = null;
    } else {
        bindedCircle = circle;
    }
}

function init() {
    var count = 0
    var delayNum = 0.02;
    var x = radius * 2;
    var y = radius * 2;
    for ( ; count < targets.length; count++) {
        var target = targets[count];
        if ( x > rootWidth - margin ) {
            x = radius * 2;
            y += margin;
            //if ( y > rootHeight - margin * 2 ) break;
        }
        var circle = C('circle');
        circle.cx = x;
        circle.cy = y;
        circle.r = 0;
        circle.id = target.path;
        circles.push(circle);
        circle.style = 'opacity:0.8; fill:' + randomColor();
        _('canvas').appendChild(circle);
        JSTweener.addTween(circle, {
            delay: count * delayNum,
            time: 0.5,
            r: radius
        });
        circle.addEventListener('mouseover', mouseOverHandler, false);
        circle.addEventListener('mouseout', mouseOutHandler, false);
        circle.addEventListener('mousedown', mouseDownHandler, false);
        createSpan(target.desc, String(x - radius / 2) + 'px', String(y + radius) + 'px');
        activateCircle(circle);
        x += margin;
    }

    setInterval(function() {
        pushMessage();
    }, 50);
}

</script>

<svg id = 'canvas' onload = "init()" >
<div id = 'statusbar'>
    <div id = 'messages'></div>
    <div id = 'targetinfo'>
        <table id = 'targetinfo_table'>
            <tr><th>Desc :</th><td id = 'targetinfo_desc'></td></tr>
            <tr><th>Path :</th><td id = 'targetinfo_path'></td></tr>
            <tr><th>Max :</th><td id = 'targetinfo_max'></td></tr>
            <tr><th>Min :</th><td id = 'targetinfo_min'></td></tr>
            <tr><th>Curr :</th><td id = 'targetinfo_curr'></td></tr>
        </table>
    </div>
</div>
