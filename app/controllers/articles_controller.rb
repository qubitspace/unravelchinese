class ArticlesController < ApplicationController
  #Pundit https://github.com/elabs/pundit
  #after_action :verify_authorized#, :except => :index
  #after_action :verify_policy_scoped, :only => :index

  def new
    form Article::Create
  end

  def create
    process_params! params
    run Article::Create do |o|
      return redirect_to o.model
    end

    render action: :new
  end

  # def create_comment
  #   present Thing::Update
  #   run Comment::Create do |op| # overrides @model and @form!
  #     flash[:notice] = "Created comment for \"#{op.thing.name}\""
  #     return redirect_to thing_path(op.thing)
  #   end

  #   render :show
  # end


  def index
    authorize :articles, :index?
    #@articles = Article.order('created_at desc').all
    @articles = policy_scope(Article).order('created_at desc').all
  end

  def show
    present Article::Update
    form Comment::Create
    #@stats = @article.get_stats current_user
  end

  def update
    run Article::Update do |o|
      return redirect_to o.model
    end

    render action: :edit
  end

  def edit
    form Article::Update
  end


  def update_word_status
    @word = Word.find(params[:word_id])
    @word.update_status current_user, params[:status]

    @article = Article.find(params[:article_id])
    @stats = @article.get_stats current_user

    respond_to do |format|
      format.js
    end
  end


  def create_comment
    present Article::Update
    run Comment::Create do |o|
      flash[:notice] = "Created comment for \"#{o.article.title}\""
      return redirect_to article_path(o.article)
    end

    render :show
  end


  def next_comments
    present Thing::Update

    render js: concept("comment/cell/grid", @thing, page: params[:page]).(:append)
  end


  private
  # def process_params!(params)
  #   params.merge!(current_user: current_user)
  # end

  # def tokenized_article id
  #   Article.includes(
  #     :source,
  #     :sentences => [
  #       { :translations => :source },
  #       { :tokens => { :word => :definitions } }
  #     ]).find(id)
  # end

  # def article_params
  #   params.require(:article).permit(
  #     :source_id,
  #     :link,
  #     :title,
  #     :description,
  #     :body,
  #     :commentable,
  #     :publishable
  #   )
  # end

end

# Normalizing params
# Override #process_params! to add or remove values to params before the operation is run. This is called in #run, #respond and #present.
# class CommentsController < ApplicationController
#   # ..

# private
#   def process_params!(params)
#     params.merge!(current_user: current_user)
#   end
# end