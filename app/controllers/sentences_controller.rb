class SentencesController < ApplicationController
  def index
    @sentences = Sentence.all
  end

  def show
    @sentence = Sentence.find params[:id]
  end

  def copy_text
    sentence = Sentence.find params[:sentence_id]
    @text = sentence.value

    respond_to do |format|
      format.js
    end
  end

  def update_word_status
    @word = Word.find(params[:word_id])
    @word.update_status current_user, params[:status]

    @sentence = Article.find(params[:sentence_id])
    #@stats = @sentence.get_stats current_user

    respond_to do |format|
      format.js
    end
  end

  private

  def sentence_params
    params.require(:sentence).permit(:rank, :value, :end, translations_attributes: [:id, :_destroy, :value ])
  end

end
