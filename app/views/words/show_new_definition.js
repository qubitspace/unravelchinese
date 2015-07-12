$('#definitions').append('<%= j concept("definition/definition_cell/manage_definition_cell", @definition, current_user: current_user).call(:show) %>');

$('#new_definition')
  .replaceWith('<%= escape_javascript(render partial: "new_definition_form", locals: { form: @new_form, definition: @definition }) %>');
