class LearnedWordsController < ApplicationController


  def update_status
    word = Word.find(params[:word_id])

    @learned_word = LearnedWord.find_or_create_by(user: current_user, word: word)
    @learned_word.status = params[:status]

    if params[:status] == 'known'
      if @learned_word.status != params[:status].to_sym
        @learned_word.save
      end
    elsif params[:status] == 'unknown'
      @learned_word.destroy
    end

    respond_to do |format|
      format.js
    end
  end

end
