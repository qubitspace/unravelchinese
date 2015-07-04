$('.definition_cell[definition-id="<%= @definition.id %>"]')
  .replaceWith('<%= j concept("definition/definition_cell/definition_manage_cell", @definition, current_user: current_user, errors: @definition_form.errors).call(:show) %>');

