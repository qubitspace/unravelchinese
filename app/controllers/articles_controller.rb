class ArticlesController < ApplicationController
  include Concerns::Manageable
  skip_before_action :require_login, only: [:index]

  def index
    authorize Article
    @articles = policy_scope(Article).order('created_at desc').where('? is null or category_id = ?', params[:category_id], params[:category_id]).all
  end

  def show
    @article = get_article params[:id]
    authorize @article

    @form = Comment::Form.new(Comment.new)

    @user_stats = current_user ? current_user.get_stats : {}
    @article_stats = @article.get_stats current_user
  end

  #def new
  #  authorize Article
  #  @form = Article::Form.new(new_article)
  #end

  def create
    authorize Article

    display_type = params[:article][:display_type]
    form = Article::Form.new(new_article)

    if form.validate(params[:article])
      form.sync
      article = form.model

      form.save do |f|
        if f[:article_source].present?
          article.source = Source.find form[:source]
        else
          article.source = nil
        end
        article.save
        render js: concept("article/article_cell/#{display_type}", form.model, current_user: current_user).(:prepend)
      end
    else
      render js: concept("article/article_form_cell", form, current_user: current_user, display_type: display_type).(:show_new_form)
    end
  end

  def edit
    authorize Article
    @form = Article::Form.new(Article.includes(:source).find(params[:id]))
  end

  def update
    article = Article.find(params[:id])
    authorize article

    display_type = params[:article][:display_type]
    form = Article::Form.new(article)

    if form.validate(params[:article])
      form.sync
      article = form.model
      form.save do |f|
        unless f[:source].empty?
          article.source = Source.find f[:source]
        end
        article.save
      end
      render js: concept("article/article_cell/#{display_type}", article, current_user: current_user, display_type: display_type).(:refresh)
    else
      render js: concept("article/article_form_cell", form, current_user: current_user, display_type: display_type).(:show_edit_form)
    end
  end

  def manage
    @article = get_article params[:article_id]
    authorize @article

    sentence_ids = []
    @article.sections.each do |section|
      if section.resource_type == 'Sentence'
        section.is_clone = sentence_ids.include?(section.resource_id)
        sentence_ids << section.resource_id
      end
    end

    sentence = Sentence.new
    sentence.translations.build

    section = Section.new(
      article: @article,
      sentence: sentence,
      snippet: Snippet.new
    )
    @section_form = Section::Form.new(section)
  end

  def add_sentence_section
    article = Article.includes(:sentences).find(params[:sentence][:section_attributes][:article_id])
    authorize article

    section = Section.new
    article.sentences.each do |s|
      if s.value == sentence.value
        section.sentence = s
      end
    end

    if section.sentence.nil?
      sentence = Sentence.new(:section => Section.new(:article_id => article.id))
      sentence.translations.build unless params[:sentence][:translations_attributes]['0'][:value].empty?
      section.sentence = sentence
    end

    sentence_form = Section::Form.new(sentence)

    # New Sentence Form
    new_sentence = Sentence.new(:section => Section.new(:article_id => article.id))

    new_sentence.translations.build
    blank_sentence_form = Sentence::Form.new(new_sentence)

    article.sentences
    if sentence_form.validate(params[:sentence])

      sentence_form.save
      respond_to do |format|
        format.js {
          render js:
            concept("section/section_cell/manage", sentence_form.model.section, current_user: current_user).call(:append) +
            concept("sentence/sentence_form_cell", blank_sentence_form, current_user: current_user, article: article, display_type: 'manage').call(:refresh_form)
        }
      end
    else
      respond_to do |format|
        format.js {
            concept("sentence/sentence_form_cell", blank_sentence_form, current_user: current_user, article: article, display_type: 'manage').call(:refresh_form)
        }
      end
    end
  end

  def create_comment
    @article = Article.find params[:id]
    authorize @article

    @form = Comment::Form.new(Comment.new)
    @form.commentable = @article
    if @form.validate(params[:comment])
      @form.save
      flash[:notice] = "Created comment for \"#{@article.title}\""
      return redirect_to article_path(@article)
    end

    render :show
  end


  def next_comments
    #present Article::Update
    # using .(:append) will mark the results as html safe and applies caching
    #render js: concept("comment/comment_cell/comment_grid", @article, page: params[:page]).(:append)
  end

  def view_raw_content
    # iterate through sentences and collect raw chinese
      # check if it's an end of a paragraph
    # display this somewhere
  end

  def view_raw_translation
    # iterate through sentences and collect primary translations
      # check if it's an end of a paragraph
    # display this somewhere
  end

  def import
    article = get_article params[:article_id]
    authorize article

    value = params["article_import"]["import_sentences"]
    value.gsub /^$\n/, ''
    if value.present?
      sort_order = article.next_sort_order

      value.split("\n").each_slice(2) do |pair|
        simplified = pair[0]
        translation = pair[1]

        # TODO: Refactor to share this code with add_sentence_section
        section = Section.new(article_id: article.id, resource_type: 'Sentence')
        article.sentences(true).each do |s|
          if s.value == simplified
            section.sentence = s
          end
        end

        if section.sentence.nil?
          sentence = Sentence.new(:section => section, value: simplified)
          sentence.translations.build(:value => translation)
          section.sentence = sentence
        end
        section.sort_order = sort_order
        sort_order += 1
        section.save
      end
    end

    redirect_to article_manage_path(article)
  end

  # TODO: turn the display into a cell (use the whole article?)
  # Then i can easily load it to the div.
  def export_sentences
    article = get_article params[:id]
    authorize article

    sentences = []
    result = "export = $('#export-sentences');"
    result += "$('#export-sentences').text('');"
    article.sentences.each do |sentence|
      result += "export.append('#{sentence.value}<br>');"
      sentence.translations.where("source_id is null").each do |translation|
        result += "export.append('test<br>');"
      end
    end

    render js: "alert('todo!');"
  end

  def re_sort
    article = policy_scope(Article).includes(:sections).find(params[:id])
    authorize article

    article.re_sort
    redirect_to article_manage_path(article)
  end

  def show_import_form
    article = get_article params[:article_id]
    authorize article
    form = Article::ImportForm.new(article)
    render js: concept("article/import_form_cell", form, current_user: current_user, display_type: params[:display_type]).(:show_import_form)
  end

  def cancel_import_form
    authorize Article
    form = model_class::Form.new(Article.new)
    render js: concept("article/import_form_cell", form, current_user: current_user).(:cancel_import_form)
  end

  def delete_all_sections
    authorize Article
    article = get_article params[:id]
    article.sections.delete_all
    redirect_to article_manage_path(article)
  end

  private

  def new_article
    policy_scope(Article).new(source: Source.new)
  end

  def get_article id
    policy_scope(Article).find(id)
  end

  def new_sentence
    Sentence.new(translation: Translation.new)
  end

  def get_article id
    article = policy_scope(Article).includes(
      { sentences: [
          { tokens: { word: :definitions } },
          { translations: :source }
        ]
      },
      :iframes,
      :photos,
      :snippets,
      :sections,
      :comments,
      :source
    ).find(id)

    article.sections.each do |section|
      case section.resource_type
      when 'Sentence'
        article.sentences.each do |sentence|
          sentence.setup_tokenizer
          if sentence.id == section.resource_id
            section.resource = sentence
            break
          end
        end
      when 'Snippet'
        article.snippets.each do |snippet|
          if snippet.id == section.resource_id
            section.resource = snippet
            break
          end
        end
      when 'Iframe'
        article.iframes.each do |iframe|
          if iframe.id == section.resource_id
            section.resource = iframe
            break
          end
        end
      when 'Photo'
        article.photos.each do |photo|
          if photo.id == section.resource_id
            section.resource = photo
            break
          end
        end
      end
    end

    return article
  end

end
