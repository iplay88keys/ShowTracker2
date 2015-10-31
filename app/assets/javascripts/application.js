// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require holder
//= require_tree .

$(".table-lst").ready(function() {
    if($('.table-lst').length == 0) return;

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

$(".table-season").ready(function() {
    if($('.table-season').length == 0) return;

    $('#table').dataTable({
        'paging': false,
        'searching': false,
        'responsive': true,
        'order': [2, 'asc'],
        'columnDefs': [{
            'targets': 0,
            'visible': false
        },
        {
            'targets': [1,5],
            'orderable': false
        },
        {
            'targets': 2,
            'orderData': [2,3]
        }]
    });
    
});

$(document).ready(function() {
    setTimeout(function(){ $('.message-box').fadeOut() }, 10000);
    
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

jQuery.fn.dataTableExt.oApi.fnFindCellRowIndexes = function ( oSettings, sSearch, iColumn ) {
  var
    i,iLen, j, jLen, val,
    aOut = [], aData,
    columns = oSettings.aoColumns;
 
  for ( i=0, iLen=oSettings.aoData.length ; i<iLen ; i++ ) {
    aData = oSettings.aoData[i]._aData;
 
    if ( iColumn === undefined ) {
      for ( j=0, jLen=columns.length ; j<jLen ; j++ ) {
        val = this.fnGetData(i, j);
        if ( val == sSearch ) {
          aOut.push( i );
        }
      }
    }
    else if (this.fnGetData(i, iColumn) == sSearch ) {
      aOut.push( i );
    }
  }
 
  return aOut;
};

function deleteFromWatchlist(userid, series, name) {
  if(deleteItem()) {
    var url = "/api/v1/user/" + userid + "/watchlist";
    data = {};
    data.series_id = series;
    $.ajax({
      url: url,
      type: "DELETE",
      data: data,
      success: function(resp) {
        if (resp["status"] == 200) {
          var table = $('#table').DataTable();
          var index = $('#table').dataTable().fnFindCellRowIndexes(series, 0, 1);
          $('#tooltip').remove();
          table.row(index).remove();
          table.draw();
          
          createAlert("success", name + " successfully deleted from watchlist");
        }
      }
    });
  }
}

function addToWatchlist(userid, series, name) {
  var url = "/api/v1/user/" + userid + "/watchlist";
  data = {};
  data.series_id = series;
  $.ajax({
    url: url,
    type: "POST",
    data: data,
    success: function(resp) {
        createAlert("success", name + " successfully added to watchlist");
    }
  });
}

function watchedChanged(checkbox, userid, series, episode, season, name) {
    var checked = checkbox.checked;
    if(checked === true) {
        addWatched(userid, series, episode, season, name); 
    } else {
        removeWatched(userid, series, episode, season, name);
    }
}

function addWatched(userid, series, episode, season, name) {
    var url = "/api/v1/series/" + series + "/episode/" + episode;
    data = {};
    data.user_id = userid;
    data.season_id = season;
    $.ajax({
        url: url,
        type: "POST",
        data: data,
        success: function(resp) {
            if(resp["status"] == 200) {
                createAlert("success", name + " successfully added as watched");
            } else {
                createAlert("error", "Something went wrong. Please refresh.")
            }
        }
    })
}

function removeWatched(userid, series, episode, season, name) {
    var url = "/api/v1/series/" + series + "/episode/" + episode;
    data = {};
    data.user_id = userid;
    data.season_id = season;
    $.ajax({
        url: url,
        type: "DELETE",
        data: data,
        success: function(resp) {
            if(resp["status"] == 200) {
                createAlert("success", name + " successfully removed from watched");
            } else {
                createAlert("error", "Something went wrong. Please refresh.")
            }
        }
    })
}

function deleteItem() {
  if (confirm("Are you sure? This cannot be undone.")) {
    return true;
  }
  return false;
}

function createAlert(type, text) {
    html = $("<div class='alert alert-" + type + " alert-dismissable'>").append($("<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>")).append("<p>" + text  + "</p>");
    $(".message-box").empty();
    $(".message-box").append(html);
    if(!$(".message-box").attr("style")) {
      $(".message-box").css("display", "none");
    }
    $(".message-box").removeAttr("style");
    setTimeout(function(){ $('.message-box').fadeOut() }, 10000);
}
