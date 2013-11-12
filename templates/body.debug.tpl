<div class = 'debug'>
<table class = 'table table-bordered table-striped table-hover'>
    <tr>
        <th>Plugin Belongs To</th>
        <th>Path ( Metric Name )</th>
        <th>Max Value</th>
        <th>Min Value</th>
    </tr>
% for module, targets in targets_all.items():
    % for t in targets:
    <tr>
        <th>{{module}}</th>
        <td>{{t['path']}}</td>
        <td>{{t['max']}}</td>
        <td>{{t['min']}}</td>
    </tr>
    % end
% end
</table>
<script>
document.body.style.overflow = 'auto';
</script>
</div>
