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
    
    function setXY(e, height){
        if ($('#tooltip').outerHeight(true) + e.pageY + 100 > height){        
            $('#tooltip').css('top', e.pageY - $('#tooltip').outerHeight(true));
        } else {
            $('#tooltip').css('top', e.pageY);
        }
        
        $('#tooltip').css('left', e.pageX);
    }

    $('.overview').hover(function(e){
        var text = $(this)[0].innerHTML;
        var html = "<div id='tooltip'>" + $.trim(text) + "</div>";
        var height = $(document).outerHeight(true);
        $(document.body).append(html);
        
        setXY(e, height);

    }, function(e){
        $('#tooltip').remove();
    });

    $('.overview').mousemove(function(e){
        var height = $(document).outerHeight(true);
        setXY(e, height);
    });
});
