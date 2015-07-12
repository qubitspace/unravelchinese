
$('#sentences').append('<%= j concept("sentence/sentence_cell/manage_sentence_cell", @sentence, current_user: current_user).call(:show) %>');

$('#new_sentence')
  .replaceWith('<%= escape_javascript(render partial: "new", locals: { form: @new_form, definition: @sentence }) %>');
