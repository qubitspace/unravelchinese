function addToggleNewSource() {
  $('#article_source_id').change(function() {
    if($(this).val() == '') {
      $('input#article_source_attributes_name').prop('disabled', false);
      $('input#article_source_attributes_link').prop('disabled', false);
    } else {
      $('input#article_source_attributes_name').val('');
      $('input#article_source_attributes_link').val('');
      $('input#article_source_attributes_name').prop('disabled', true);
      $('input#article_source_attributes_link').prop('disabled', true);
    }
  });
}


var ready;
ready = function() {
    addToggleNewSource();
};

$(document).ready(ready);
$(document).on('page:load', ready);
