<table>
% for module, targets in targets_all.items():
    <tr>
        <th>{{module}}<th>
        <td> 
            <table>
            % for t in targets:
                <tr>
                    <th>path:</th><td>{{t['path']}}</th>
                    <th>desc:</th><td>{{t['desc']}}</th>
                    <th>max:</th><td>{{t['max']}}</th>
                    <th>min:</th><td>{{t['min']}}</th>
                </tr>
            % end
            </table>
        </td> 
    </tr>
% end
</table>
