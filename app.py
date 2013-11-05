#!/usr/bin/env python

import os, logging, json, urllib2, re, sys, random
from collections import defaultdict
import plugins
import config
from bottle import route, run, template, static_file, default_app

logging.basicConfig(format = '%(asctime)-15s %(message)s', level = logging.DEBUG)
targets_all = {}
categories = defaultdict(list)

def randomcolor():
    r = hex(int(random.random() * 64 + 127))[2:];
    g = hex(int(random.random() * 64 + 127))[2:];
    b = hex(int(random.random() * 64 + 127))[2:];
    return '#' + r + g + b;

def load_metrics():
    url = config.graphite_url + '/metrics/index_all.json'
    try:
        if os.path.exists(config.metrics_file) and config.debug:
            data = open(config.metrics_file).read()
        else:
            data = urllib2.urlopen(url).read()
        metrics = json.loads(data)
        if config.debug:
            open(config.metrics_file, 'w').write(json.dumps(metrics))
    except Exception, e:
        logging.warning(str(e))
        sys.exit(1)
    return metrics

def load_plugins():
    global targets_all
    plugins_dir = os.path.dirname(plugins.__file__)
    metrics = load_metrics()
    for f in os.listdir(plugins_dir):
        if f == '__init__.py' or not f.endswith('.py'):
            continue
        module = f[:-3]
        matched_dict = {}
        matched = []
        try:
            plugin = __import__('plugins.' + module, globals(), locals(), ['*'])
            for t in plugin.targets:
                color = randomcolor()
                for m in metrics:
                    if matched_dict.has_key(m): continue
                    if re.search(t.get('reg'), m):
                        matched_dict[m] = True
                        matched.insert(0, {'desc':str(m),'path':str(m),'max':t['max'],'min':t['min'], 'color':color})
            targets_all[module] = matched
            if hasattr(plugin, 'category') and not callable(getattr(plugin, 'category')):
                category = plugin.category.lower()
            else:
                category = 'default'
            categories[category].append(module)
            logging.info('Loading plugin - %s', module)
        except Exception, e:
            print e
            logging.info('Error when loading plugin - %s', module)
load_plugins()


def render_page(body, page='index', **kwargs):
    return str(template('templates/base', body = body, page = page, **kwargs))


@route('/', method = 'GET')
@route('/index', method = 'GET')
@route('/dashboard', method = 'GET')
def index():
    body = template('templates/body.index', targets_all = targets_all, categories = categories)
    return render_page(body)


@route('/dashboard/:plugin', method = 'GET')
def dashboard(plugin = ''):
    body = template('templates/body.dashboard', targets = targets_all[plugin])
    return render_page(body, page = 'dashboard', plugin = plugin)


@route('/metric_value/:metric_name', method = 'GET')
def metric_value(metric_name = ''):
    try:
        url = config.graphite_url.rstrip('/') + '/render/?from=-1min&format=json&target='
        datapoints = json.loads(urllib2.urlopen(url + metric_name).read())[0]['datapoints']
        # average value in last 1 min
        value = [p[0] for p in datapoints if p[0] is not None][-1]
        value = float('%.2f' % value)
    except Exception, e:
        print e
        value = -9999
    return json.dumps(value)


@route('/debug', method = 'GET')
def debug():
    body = template('templates/body.debug', targets_all = targets_all)
    return render_page(body, page = 'debug')


@route('<path:re:/static/css/.*css>')
@route('<path:re:/static/js/.*js>')
@route('<path:re:/static/fonts/.*woff>')
def static(path, method = 'GET'):
    return static_file(path, root = '.')


