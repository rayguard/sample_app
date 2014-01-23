$(document).ready(function() {
  
  $('#micropost_content').bind('keyup', function() {
    var content_length = $('#micropost_content').val().length;
    $('#micropost-counter').val(140 - content_length);
  });

});