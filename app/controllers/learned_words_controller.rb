class LearnedWordsController < ApplicationController


  def update_status
    @word = Word.find(params[:word_id])

    @learned_word = LearnedWord.find_or_create_by(user: current_user, word: @word)
    @learned_word.status = params[:status]

    if ['known', 'learning'].include? params[:status]
      @learned_word.save
    elsif
      @learned_word.destroy
    end

    @word_statuses = current_user.word_statuses
    @article = Article.find(params[:article_id])
    @stats = @article.get_stats @word_statuses
    respond_to do |format|
      format.js
    end
  end

end
