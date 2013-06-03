% setdefault('page', 'index')
% setdefault('plugin', None)
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Graphite observer</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Le styles -->
    <link href="/static/css/bootstrap.css" rel="stylesheet">
    <link href="/static/css/graphite-observer.css" rel="stylesheet">
    <script src="/static/js/jquery.min.js"></script>
    <style type="text/css">
      body {
        padding-top: 60px;
        padding-bottom: 0px;
        overflow:hidden;
      }
      .sidebar-nav {
        padding: 9px 0;
      }
    </style>

  </head>

  <body>

    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container-fluid">
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </a>
          <a class="brand" href="/index">Graphite observer</a>
          <div class="nav-collapse">
            <ul class="nav">
	% for (key, title) in [('index', 'Home'), ('debug', 'Debug'), ('dashboard', 'Dashboard' + (plugin and ' / '+plugin or ''))]:
		% if page == key:
              <li class="active"><a href="/{{key}}">{{title}}</a></li>
		% else:
              <li><a href="/{{key}}">{{title}}</a></li>
		% end
	% end
            </ul>
          </div><!--/.nav-collapse -->
            <ul class="nav pull-right">
            % import time
            <li><a>{{time.asctime()}}</a> </li>
            </ul>
        </div>
      </div>
    </div>
    <div id = 'content' style = 'margin-left: 20px;'>
    {{!body}}
    </div>

  </body>
</html>
