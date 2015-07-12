$('#new_definition')
  .replaceWith('<%= escape_javascript(render partial: "new_definition_form", locals: { form: @form, definition: @definition }) %>');
