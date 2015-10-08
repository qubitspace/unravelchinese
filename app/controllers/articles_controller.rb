class ArticlesController < ApplicationController
  include Concerns::Manageable

  def index
    authorize :articles, :index?
    @articles = policy_scope(Article).order('created_at desc').where('? is null or category_id = ?', params[:category_id], params[:category_id]).all
  end

  def show
    @article = get_article params[:id]
    @form = Comment::Form.new(Comment.new)
  end

  def new
    @form = Article::Form.new(new_article)
  end

  def create
    @form = Article::Form.new(new_article)

    if @form.validate(params[:article])
      @form.sync
      article = @form.model

      @form.save do |form|
        if form[:article_source].present?
          article.source = Source.find form[:source]
        else
          article.source = nil
        end
        article.save
      end

      # Redirect to manage article to set up sentences
      # Then have a link from the sentence cell to a manage sentence page to add tokenize?
      return redirect_to @form.model
    end
    render action: :new
  end

  def edit
    @form = Article::Form.new(Article.includes(:source).find(params[:id]))
  end

  def update
    display_type = params[:article][:display_type]
    article = Article.find(params[:id])
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
    article = Article..includes(:sentences).find(params[:sentence][:section_attributes][:article_id])
    section = Section.new
    article.sentences.each do |s|
      if s.value == sentence.value and s.
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


  # add_photo and add_iframe can probably be merged into a single action.
  # Should i move them to the sections controller
  def add_iframe
    @article = Article.find params[:id]
    @form = Section::Form.new(Section.new)
    @form.article = @article
    if @form.validate(params[:section])
      @form.save
      flash[:notice] = "Created section"
      return redirect_to article_manage_path(@article)
    end

    render :manage
  end


  def create_comment
    @article = Article.find params[:id]
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
    present Article::Update
    # using .(:append) will mark the results as html safe and applies caching
    render js: concept("comment/comment_cell/comment_grid", @article, page: params[:page]).(:append)
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

  def resort
    article = Article.includes(:sections).find(params[:id])
    article.resort
    redirect_to article_manage_path(article)
  end

  private

  def new_article
    Article.new(source: Source.new)
  end

  def new_sentence
    Sentence.new(translation: Translation.new)
  end


  def get_article id
    article = Article.includes(
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
