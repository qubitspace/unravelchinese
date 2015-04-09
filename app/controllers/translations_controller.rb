class TranslationsController < ApplicationController

  def create
    @sentence = Sentence.find(params[:sentence_id])
    @translation = @sentence.translations.create(translation_params)
    redirect_to sentence_path(@sentence)
  end

  def destroy
    # @article = Article.find(params[:article_id])
    # @comment = @article.comments.find(params[:id])
    # @comment.destroy
    # redirect_to article_path(@article)
  end


  def upvote
    @translation = Translation.find(params[:id])

    unless current_user.voted_for_sentence @translation.sentence
      @translation.upvote_by current_user
    end

    redirect_to @translation.sentence #todo: change to ajax.
  end

  def downvote
    @translation = Translation.find(params[:id])

    unless current_user.voted_for_sentence @translation.sentence
      @translation.downvote_by current_user
    end
    redirect_to @translation.sentence #todo: change to ajax.
  end

  def unvote
    @translation = Translation.find(params[:id])

    if current_user.voted_up_on? @translation
      @translation.unliked_by current_user
    elsif current_user.voted_down_on? @translation
      @translation.undisliked_by current_user
    end
    redirect_to @translation.sentence #todo: change to ajax.
  end

  private

  def translation_params
    params.require(:translation).permit(:value)
  end
end
