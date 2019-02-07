$(document).ready(function(){
  $('#testtime_tabs a').click(function (e) {
    e.preventDefault();
    $(this).tab('show');
  });
});