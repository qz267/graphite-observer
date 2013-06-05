# Graphite observer

A realtime monitor dashboard for [Graphite](https://github.com/graphite-project/graphite-web).

The code is simple and hackable, no more than 1000 lines.

Thanks to : [graph-explorer](https://github.com/vimeo/graph-explorer), [maptail](https://github.com/stagas/maptail), [JSTweener](http://coderepos.org/share/wiki/JSTweener), I have merged styles of these three into graphite-observer.

# Screenshot

![Screenshot](https://raw.github.com/huoxy/graphite-observer/master/static/image/dashboardScreenshot.png)

# Configuration

in config.py:

```python
graphite_url = 'http://graphitehost:port'
listen_host = '0.0.0.0'
listen_port = 8801
```

the `graphite_url` should be your graphite web location.

# Plugin

A plugin is a python file in which defines a list whose element is:
* desc: description of this target
* path: metric name
* max: max value of this metric
* min: min value of this metric

For example, `plugins/example.py` has content:

```python
targets = [
    {  
        'desc'  : 'hostA cpu',
        'path'  : 'servers.hostA.cpu.total.user',
        'max'   : 400,
        'min'   : 0
    }, 
    {
        'desc'  : ' hostB cpu',
        'path'  : 'servers.hostB.cpu.total.user',
        'max'   : 500,
        'min'   : 0
    },
]

category = 'sysadmin'
```

then you can view states of these metrics via `http://<ip>:<port>/dashboard/example`.

Browser will infinitely use this conf to determine a metric is in good state or bad.

If `metric_value` of `target['path']` is greater than `target['max']` or less than `target['min']`, it is in bad state.

If in bad state, the corresponding `Circle` drew in previous Screenshot will keep zooming in/out.

# Category
A plugin belongs to a `category`, this is defined in plugin files.
For example, in plugin `example.py`, a variable named `category` is defined as:
```python
category = 'sysadmin'
```

then `example.py` will belong to category `sysadmin`, and plugins will be listed group by category

![Screenshot](https://raw.github.com/huoxy/graphite-observer/master/static/image/indexScreenshot.png)

# Requirement
* python2: either 2.6 or higher.

# Running
* default: `./graphite-observer.py` and your page is available at `http://<ip>:8801`
* alternatively, if you use gunicorn, you can run it with multi-workers like so: `gunicorn -w 4 app:'default_app()' -b 0.0.0.0:8801`

# Logging

* On left-bottom of dashboard page, there is real time log which will be automatically refreshed.
* When you press a circle to "bind" it to right-bottom, it will refresh info only about this metric.
