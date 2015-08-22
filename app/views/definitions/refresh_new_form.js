$('#new_definition')
  .replaceWith('<%= escape_javascript(render partial: "new", locals: { form: @form, definition: @definition }) %>');
