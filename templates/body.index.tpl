<div id = 'index_sidebar'>
    <div id = 'gettingstarted' class = 'well'>
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
    <div id = 'ineedhelp' class = 'alert alert-info'>
    <strong>This project needs your help!</strong>
    <br />
    Luckily for you, the code is easy to grasp and hack.
    </div>
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
