class SentencesController < ApplicationController

  def index
    @sentences = Sentence.all
  end

  def show
    @sentence = Sentence.find params[:id]
  end

  def new
    @form = Sentence::Form.new(Sentence.new)
  end

  def create
    run Sentence::Create do |op|
      flash[:notice] = "Created sentence for \"#{op.sentence.name}\""
      return redirect_to article_path(@article)
    end
    @article = Article.find(params[:article_id])
    render :new
  end

  # def destroy
  #   @sentence = Sentence.find params[:id]
  #   @sentence.destroy

  #   redirect_to [:admin, @sentence.article]
  # end

  def manage
    @sentence = Sentence.find params[:sentence_id]

    @sentence.untokenized = @sentence.value.dup
    @sentence.tokens.each do |token|
      @sentence.untokenized.slice! token.word.simplified
    end

    @words = Word.all
    @candidate_tokens = get_candidate_tokens @sentence.untokenized
  end


  # def copy_text
  #   sentence = Sentence.find params[:sentence_id]
  #   @text = sentence.value

  #   respond_to do |format|
  #     format.js
  #   end
  # end

  # def update_word_status
  #   @word = Word.find(params[:word_id])
  #   @word.update_status current_user, params[:status]

  #   @sentence = Article.find(params[:sentence_id])
  #   #@stats = @sentence.get_stats current_user

  #   respond_to do |format|
  #     format.js
  #   end
  # end

  # private

  # def sentence_params
  #   params.require(:sentence).permit(:rank, :value, :end, translations_attributes: [:id, :_destroy, :value ])
  # end

  # def untokenize
  #   @sentence = Sentence.find params[:id]
  #   @sentence.tokens.delete_all
  #   redirect_to manage_admin_sentence_path(@sentence)
  # end

  # def add_token
  #   @sentence = Sentence.find params[:id]
  #   word = Word.find params[:word_id]

  #   @sentence.untokenized = @sentence.value.dup
  #   @sentence.tokens.each do |token|
  #     @sentence.untokenized.slice! token.word.simplified
  #   end

  #   if @sentence.untokenized.present? or @sentence.untokenized =~ /^#{word.simplified}/
  #     token_rank = @sentence.tokens.size == 0 ? 0 : @sentence.tokens.map(&:rank).max + 1
  #     token = Token.create sentence: @sentence, word: word, rank: token_rank
  #     @sentence.untokenized.slice! token.word.simplified
  #     @candidate_tokens = get_candidate_tokens @sentence.untokenized
  #     @sentence.reload
  #   else
  #     @candidate_tokens = get_candidate_tokens @sentence.untokenized
  #     flash[:alert] = "Error adding token. Token word didn't match untokenized text."
  #     render js: "window.location = '#{tokenize_sentence_path(@sentence)}'"
  #     return
  #   end

  #   respond_to do |format|
  #     format.js
  #   end
  # end

  private

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
