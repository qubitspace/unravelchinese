class SentencesController < ApplicationController

  def tokenize
    @learned_words = current_user.words
    @word_statuses = current_user.word_statuses
    @sentence = Sentence.find params[:id]

    @sentence.untokenized = @sentence.value.dup
    @sentence.tokens.each do |token|
      @sentence.untokenized.slice! token.word.simplified
    end

    @words = Word.all
    @candidate_tokens = get_candidate_tokens @sentence.untokenized
  end

  def untokenize
    @sentence = Sentence.find params[:id]
    @sentence.tokens.delete_all
    redirect_to tokenize_sentence_path(@sentence)
  end

  def add_token
    @learned_words = current_user.words
    @word_statuses = current_user.word_statuses
    @sentence = Sentence.find params[:sentence_id]
    word = Word.find params[:word_id]

    @sentence.untokenized = @sentence.value.dup
    @sentence.tokens.each do |token|
      @sentence.untokenized.slice! token.word.simplified
    end

    if @sentence.untokenized.present? or @sentence.untokenized =~ /^#{word.simplified}/
      token_rank = @sentence.tokens.size == 0 ? 0 : @sentence.tokens.map(&:rank).max + 1
      token = Token.create sentence: @sentence, word: word, rank: token_rank
      @sentence.untokenized.slice! token.word.simplified
      @candidate_tokens = get_candidate_tokens @sentence.untokenized
      @sentence.reload
    else
      @candidate_tokens = get_candidate_tokens @sentence.untokenized
      flash[:alert] = "Error adding token. Token word didn't match untokenized text."
      render js: "window.location = '#{tokenize_sentence_path(@sentence)}'"
      return
    end

    respond_to do |format|
      format.js
    end
  end

  def get_candidate_tokens untokenized

    matches = []
    return matches unless untokenized.present?

    potential_matches = untokenized.empty? ? [] : Word.where("simplified LIKE :prefix", prefix: "#{untokenized[0]}%")
    potential_matches.each do |word|
      matches << word if word.simplified == untokenized[0...word.simplified.length]
    end
    if matches.empty?
      if untokenized[/^([a-zA-Z0-9_.-]*)/,1].length > 0
        word = Word.find_or_create_by simplified: untokenized[/^([a-zA-Z0-9_.-]*)/,1], category: :alphanumeric
      else
        word = Word.find_or_create_by simplified: untokenized[0], category: :alphanumeric
      end
      matches << word
    end
    return matches.sort_by { |y| -y.simplified.length} # TODO: add sort by how often it's used in the site.
  end


end
