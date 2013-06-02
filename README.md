# Graphite observer

A realtime monitor dashboard for
[Graphite](https://github.com/graphite-project/graphite-web)

The code is simple and hackable, no more than 500 lines (include html)

Plugin is supported, a plugin is a python file in which defines a list
whose element is:
* path: metric name
* desc: description of this target
* max: max value of this metric
* min: min value of this metric

![Screenshot](https://raw.github.com/huoxy/graphite-observer/master/Screenshot.png)

