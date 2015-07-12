$('.definition_cell[definition-id="<%= @definition.id %>"]')
  .replaceWith('<%= j concept("definition/definition_cell/manage_definition_cell", @definition, current_user: current_user).call(:show) %>');

