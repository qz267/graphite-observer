<div id = 'index_sidebar'>
<h4><b>GETTING STARTED</b></h4>
<p>
want a custom page? write a new plugin refer to <a href = 'https://github.com/huoxy/graphite-observer#plugin'>wiki</a> and send your pull request.
</p>
<p>
if your a plugin 'example.py', then '/dashboard/example' will be your page.
</p>
<p>
<a href = '/debug'>debug</a> page will show all plugins.
</p>
</div>
<div id = 'dashboard_container'>
<ul>
% for plugin in targets_all.keys():
    <li><span><a class = 'dashboard_a' href = '/dashboard/{{plugin}}'>{{plugin}}</a></span></li>
% end
</ul>
</div>
