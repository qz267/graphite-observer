<div class = 'well' id = 'index_sidebar'>
<h4><b>GETTING STARTED</b></h4>
<p>
want a custom page? write a new plugin refer to <a href = 'https://github.com/huoxy/graphite-observer#plugin'>wiki</a> and send your pull request.
</p>
<p>
if your plugin is 'example.py', then '/dashboard/example' will be your page.
</p>
<p>
<a href = '/debug'>debug</a> page will show config of all plugins.
</p>
</div>
<div id = 'dashboard_container'>
% for category in sorted(categories.keys()):
    % members = categories[category]
    <div class = 'category'>
        <h3 class = 'category'><b>{{category}}</b> &#187;</h3>
        <ul>
        % for plugin in sorted(members):
            <li><a href = '/dashboard/{{plugin}}'>{{plugin}}</a></li>
        % end
        </ul>
    </div>
% end
</div>
