#!/usr/bin/env python

import os, logging, json, urllib2
from collections import defaultdict
import plugins
import config
from bottle import route, run, template, static_file, default_app

logging.basicConfig(format = '%(asctime)-15s %(message)s', level = logging.DEBUG)
targets_all = {}
categories = defaultdict(list)

def load_plugins():
    global targets_all
    plugins_dir = os.path.dirname(plugins.__file__)
    for f in os.listdir(plugins_dir):
        if f == '__init__.py' or not f.endswith('.py'):
            continue
        module = f[:-3]
        try:
            plugin = __import__('plugins.' + module, globals(), locals(), ['*'])
            targets_all[module] = plugin.targets[:40]
            if hasattr(plugin, 'category') and not callable(getattr(plugin, 'category')):
                category = plugin.category.lower()
            else:
                category = 'default'
            categories[category].append(module)
            logging.info('Loading plugin - %s', module)
        except:
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
    except:
        value = None
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


