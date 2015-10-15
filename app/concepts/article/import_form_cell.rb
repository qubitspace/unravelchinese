class Article::ImportFormCell < Cell::Concept
  include Cell::ManageableForm

  def show_import_form
    %{
      $('#import-sentences').prepend('#{j(render :import_article_form)}');
    }
  end

  def cancel_import_form
    %{
      $('.article[article-id="new"]').remove();
    }
  end

end