class CommentsController < ApplicationController
  def create
    run Comment::Create do |op|
      flash[:notice] = "Created comment for \"#{op.thing.name}\""
      return redirect_to article_path(@article)
    @article = Article.find(params[:article_id]) # UI-specific logic!
    render :new
    # @article = Article.find(params[:article_id])
    # @comment = @article.comments.create(comment_params)
    # redirect_to article_path(@article)
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to article_path(@article)
  end


  private


  def comment_params
    params.require(:comment).permit(:body)
  end
end
