class CommentsController < ApplicationController

  def create
    run Comment::Create do |op|
      flash[:notice] = "Created comment for \"#{op.comment.name}\""
      return redirect_to article_path(@article)
    @article = Article.find(params[:article_id])
    render :new
  end


  ###########################
  ### Non-Operation Based ###
  ###########################

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to article_path(@article)
  end

end
