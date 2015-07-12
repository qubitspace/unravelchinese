$('#new_sentence')
  .replaceWith('<%= escape_javascript(render partial: "new", locals: { form: @form, sentence: @sentence }) %>');
