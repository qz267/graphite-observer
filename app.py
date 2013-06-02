#!/usr/bin/env python

import os, importlib, logging, json, urllib2
import plugins
import config
from bottle import route, run, template, static_file

logging.basicConfig(format = '%(asctime)-15s %(message)s', level = logging.DEBUG)
targets_all = {}

def load_plugins():
    global targets_all
    plugins_dir = os.path.dirname(plugins.__file__)
    for f in os.listdir(plugins_dir):
        if f == '__init__.py' or not f.endswith('.py'):
            continue
        module = f[:-3]
        try:
            plugin = importlib.import_module('plugins.' + module)
            targets_all[module] = plugin.targets
            logging.info('Loading plugin - %s', module)
        except:
            logging.info('Error when loading plugin - %s', module)
load_plugins()


def render_page(body, page='index'):
    return str(template('templates/base', body = body, page = page))


@route('/', method = 'GET')
@route('/index', method = 'GET')
def index():
    body = template('templates/body.index', targets_all = targets_all)
    return render_page(body)


@route('/dashboard/:plugin', method = 'GET')
def dashboard(plugin = ''):
    body = template('templates/body.dashboard', targets = targets_all[plugin])
    return render_page(body)


@route('/metric_value/:metric_name', method = 'GET')
def metric_value(metric_name = ''):
    try:
        url = config.graphite_url + '/render/?from=-1min&format=json&target='
        datapoints = json.loads(urllib2.urlopen(url + metric_name).read())[0]['datapoints']
        # average value in last 1 min
        value = float(sum([p[0] for p in datapoints if p[0] is not None])) / len(datapoints)
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
def static(path, method = 'GET'):
    return static_file(path, root = '.')

run(host = config.listen_host, port = config.listen_port, debug = True)


