<svg id = 'canvas' onload = "init()" >
<script src="/static/js/JSTweener.js"></script>
<script>

const SVG = "http://www.w3.org/2000/svg";
const XLINK = "http://www.w3.org/1999/xlink";

//var log = console.log;
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

var rootHeight = document.defaultView.innerHeight;
var rootWidth = document.defaultView.innerWidth;

var margin = 50;
var radius = 20;
var circles = [];

function init() {
    var count = 1;
    var jCount = 0;
    var delayNum = 0.02;
    for (var j = 0; j < rootHeight + margin; j += margin) {
        var iCount = 0;
        for (var i = 0; i < rootWidth + margin; i += margin) {
                iCount++;
                var circle = C('circle');
                circles.push(circle);
                circle.cx = i;
                circle.cy = j;
                circle.r = 0;
                circle.style = 'opacity:0.8; fill: ' + (((iCount + jCount)% 2 == 0) ? 'skyblue' : '#FF9F34');
                _('canvas').appendChild(circle);
                JSTweener.addTween(circle, {
                    delay: count * delayNum,
                    time: 0.5,
                    r: radius
                });
                circle.addEventListener('mouseover', mouseOverHandler, false);
                count++;
        }
        jCount++;
    }
    setTimeout(function() {
        autoMove();
        autoMove();
        autoMove();
        autoMove();
        autoMove();
    }, count * delayNum * 1000 + 1000);
}

function mouseOverHandler(e) {
    var circle = e.target;
    JSTweener.addTween(circle, {
        time: 0.2,
        r: radius * 3,
        onComplete: function() {
            JSTweener.addTween(circle, {
                time:2,
                r: radius
            });
        }
    });
}

function autoMove() {
    var c1 = circles[parseInt(Math.random() * circles.length)];
    var c2 = circles[parseInt(Math.random() * circles.length)];
    if (c1.moving || c2.moving) return autoMove();

    c1.moving = true;
    c2.moving = true;
    var c1x = c1.cx;
    var c1y = c1.cy;
    var c2x = c2.cx;
    var c2y = c2.cy;
    var time = 0.1 * 1 + Math.random();
    var transition = 'linear';
    JSTweener.addTween(c1, {
        transition: transition,
        time: time,
        cx: c2x,
        cy: c2y
    });
    JSTweener.addTween(c2, {
        transition: transition,
        time: time,
        cx: c1x,
        cy: c1y,
        onComplete: function() {
            c1.moving = false;
            c2.moving = false;
            autoMove();
        }
    });
}

//$(document).ready(function(){ init(); });

</script>
