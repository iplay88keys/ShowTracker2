$(document).ready(function() {
    $('#table').dataTable({
        'paging': false,
        'searching': false,
        'responsive': true,
        'order': [1, 'asc'],
        'columnDefs': [{
            'targets': 0,
            'visible': false
        },
        {
            'targets': [2,3],
            'orderable': false
        }]
    });
});

