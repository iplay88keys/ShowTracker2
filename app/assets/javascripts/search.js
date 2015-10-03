$(document).ready(function() {
    var table = $('#table').DataTable();

    $('#add').click(function() {
        var URL_ROOT = window.location.hostname;
        var oTT = TableTools.fnGetInstance('table');
        var data = oTT.fnGetSelectedData();
        var id = data[0][0];
        if(typeof Passed.data !== 'undefined') {
            $.post('/list/add_series', {id:id}, function(data){
                if(data == 'saved') {
                    $(document).trigger('add-alerts', [{
                        'message': 'Successfuly added series to watchlist',
                        'priority': 'success'
                    }]);
                } else if (data == 'exists') {
                    $(document).trigger('add-alerts', [{
                        'message': 'Series already exists on your watchlist',
                        'priority': 'info'
                    }]);
                } else {
                    $(document).trigger('add-alerts', [{
                        'message': 'There was an error.',
                        'priority': 'error'
                    }]);
                }
            });
        }
    });
});
