# Graphite observer

A realtime monitor dashboard for
[Graphite](https://github.com/graphite-project/graphite-web)

The code is simple and hackable, no more than 500 lines (include html)

# Screenshot

![Screenshot](https://raw.github.com/huoxy/graphite-observer/master/Screenshot.png)

# Configuration

in config.py

```
graphite_url = 'http://sysmon.intra.douban.com:8000'
listen_host = '0.0.0.0'
listen_port = 8801
```

`graphite_url` should be your graphite web host:port

# Running
* default: `./graphite-observer.py` and your page is available at `<ip>:8801`
* alternatively, if you use gunicorn, you can run it with multi-workers like so: `gunicorn -w 4 app:'default_app()' -b <ip>:8080`

# Plugin

A plugin is a python file in which defines a list whose element is:
* desc: description of this target
* path: metric name
* max: max value of this metric
* min: min value of this metric

For example:
```python
targets = [
    {  
        'desc'  : 'hostA cpu',
        'path'  : 'servers.hostA.cpu.total.user',
        'max'   : 200,
        'min'   : 0
    }, 
    {
        'desc'  : ' hostB cpu',
        'path'  : 'servers.hostB.cpu.total.user',
        'max'   : 200,
        'min'   : 0
    },
]
```

Browser will use this conf to determine a metric is in good state or bad.
if `metric_value` of `targets['path']` is greater than `targets['max']` or less than `targets['min']`, it is in bad state
