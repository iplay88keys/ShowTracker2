$(document).ready(function() {
    var table = $('#table').DataTable();

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
