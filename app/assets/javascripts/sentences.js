$(document).ready(function(){
  $('.toggle_translation').click(function(event) {
    alert('test');

    var translations = $(this).next('.translations');
    translations.toggle();
    if (translations.is(':visible'))
    {
      $(this).attr('value', 'Hide Translations');
    }
    else if (translations.is(':hidden'))
    {
      $(this).attr('value', 'Show Translations');
    }
  });
});


