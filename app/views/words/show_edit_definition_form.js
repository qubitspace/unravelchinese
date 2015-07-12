$('.definition_cell[definition-id="<%= @definition.id %>"]')
  .replaceWith('<%= escape_javascript(render partial: "edit_definition_form", locals: { form: @form, definition: @definition }) %>');