<script src="/static/js/JSTweener.js"></script>
<script>

var targets_all = {{!targets_all}};

var targets_dict = {};

const SVG = "http://www.w3.org/2000/svg";
const XLINK = "http://www.w3.org/1999/xlink";

var bWidth = document.getElementsByTagName("body")[0].clientWidth;
var bHeight = document.getElementsByTagName("body")[0].clientHeight;

var rootHeight = document.defaultView.innerHeight;
var rootWidth = document.defaultView.innerWidth;

var margin = 80;
var radius = 40;

var focusedCircle;
var bindedCircle;

var messages = [];
var messages_cnt = 0;

var blank_reg = /^\s*$/;

var _ = function(name) {
    return defAttr(document.getElementById(name));
}

var C = function(type) {
    return defAttr(document.createElementNS(SVG, "circle"));
}

var n16 = function(num) {
    var str = (parseInt(num, 10)).toString(16);
    return str.length == 2 ? str : '0' + str;
};

var randomColor = function() {
    var r = n16(Math.random() * 64 + 127);
    var g = n16(Math.random() * 64 + 127);
    var b = n16(Math.random() * 64 + 127);
    return '#' + r + g + b;
};

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

function activateCircle(circle) {
    setInterval(function() {
        var plugin = circle.id;
        var targets = targets_all[plugin];
        var ok = true;
        for(var count = 0; count < targets.length; count++) {
            var target = targets[count];
            var url = '/metric_value/' + target['path'];
            console.log(target['path']);
            $.get(url, function(metric_value){
                target['curr'] = metric_value;
                //messages.push({'name' : circle.id, 'value' : metric_value});
                if ( metric_value < target.min || metric_value > target.max) {
                    ok = false;
                }
            }, 'json');
        }
        if(!ok)
            bigBang(circle);
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

function createMessage() {
    if (messages.length == 0) return null;
    var metric = messages.shift();
    var el = document.createElement('div');
    var target = targets_dict[metric.name];
    if(metric.value > target.min && metric.value < target.max) {
        el.className = 'message';
        level = "info";
    } else if (metric.value == target.min || metric.value == target.max) {
        el.className = 'message warning';
        level = "warning";
    } else {
        el.className = 'message critical';
        level = "critical";
    }
    el.innerHTML = level + " : " + metric.name + ' ' + metric.value;
    el.style.fontFamily = 'times';
    return el;
}

function pushMessage() {
    var message = createMessage();
    if(!message) return;

    var filter = $('#filter').val();
    if (! blank_reg.test(filter)) {
        try {
            var reg = RegExp(filter);
            if (! reg.test(message.innerHTML))
                return; // do not match
        } catch (err) {
            return;
        }
    }

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
}

function mouseOutHandler(e) {
    var circle = e.target;
    if(bindedCircle) {
        focusedCircle = bindedCircle;
    } else {
        focusedCircle = null;
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
    for (var plugin in targets_all) {
        if ( x > rootWidth - margin ) {
            x = radius * 2;
            y += margin;
            //if ( y > rootHeight - margin * 2 ) break;
        }
        var circle = C('circle');
        circle.cx = x;
        circle.cy = y;
        circle.r = 0;
        circle.id = plugin;
        circle.style = 'opacity: 0.7; fill: ' + randomColor();
        _('canvas').appendChild(circle);
        JSTweener.addTween(circle, {
            delay: count * delayNum,
            time: 0.5,
            r: radius
        });
        circle.addEventListener('mouseover', mouseOverHandler, false);
        circle.addEventListener('mouseout', mouseOutHandler, false);
        circle.addEventListener('mousedown', mouseDownHandler, false);
        createSpan(plugin, String(x - radius / 2) + 'px', String(y + radius) + 'px');
        activateCircle(circle);
        x += margin;
    }

    setInterval(function() {
        pushMessage();
    }, 10);
}

</script>

<svg id = 'canvas' onload = "init()" >
<div id = 'statusbar'>
    <div id = 'logs'>
        <input id = 'filter' type="text" class="input-medium search-query" placeholder="Filter: RegExp">
        <div id = 'messages'></div>
    </div>
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
