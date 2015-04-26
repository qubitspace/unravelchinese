class SentencesController < ApplicationController

  def show
    @sentence = Sentence.find params[:id]
    @word_statuses = current_user.word_statuses
  end

  def copy_text
    sentence = Sentence.find params[:sentence_id]
    @text = sentence.value

    respond_to do |format|
      format.js
    end
  end

  private

  def sentence_params
    params.require(:sentence).permit(:rank, :value, :end, translations_attributes: [:id, :_destroy, :value ])
  end

end
