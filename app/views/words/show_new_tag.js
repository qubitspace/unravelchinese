if(!$('.tagging[tagging-id="<%=@tagging.id%>"]').length) {
  $('.tags').append('<%= j concept("tagging/tagging_cell/manage_tagging_cell", @tagging, current_user: current_user).call(:show) %>');
}

$('#new_tag_form')
  .replaceWith('<%= escape_javascript(render partial: "taggable/new_tag_form", locals: { form: @new_form, taggable: @taggable }) %>');
