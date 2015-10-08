class SentencesController < ApplicationController
  include Concerns::Manageable

  def index
    @sentences = Sentence.all
  end

  def show
    @sentence = get_sentence params[:id]#Sentence.find params[:id]
  end

  # Overwrite manageable function for tokenization
  def update
    display_type = params[:sentence][:display_type]
    sentence = Sentence.find(params[:id])
    sentence.setup_tokenizer
    form = Sentence::Form.new(sentence)

    if form.validate(params[:sentence])
      form.save
      sentence.reload

      if display_type == "tokenize'"
        candidate_tokens = get_candidate_tokens sentence.untokenized
        render js: concept("sentence/sentence_cell/tokenize", sentence,
          current_user: current_user,
          display_type: 'tokenize',
          candidate_tokens: candidate_tokens).(:refresh)
      else
        render js: concept("#{model_type}/#{model_type}_cell/#{display_type}", form.model, current_user: current_user, display_type: display_type).(:refresh)
      end
    else
      render js: concept("#{model_type}/#{model_type}_form_cell", form, current_user: current_user, display_type: display_type).(:show_edit_form)
    end
  end

  def cancel_edit_form
    display_type = params[:display_type]


    if display_type != 'tokenize'
      super
    else

      sentence = Sentence.find(params[:sentence_id])
      sentence.setup_tokenizer
      candidate_tokens = get_candidate_tokens sentence.untokenized

      sentence = Sentence.find(params[:sentence_id])
        render js: concept("sentence/sentence_cell/tokenize", sentence,
          current_user: current_user,
          display_type: 'tokenize',
          candidate_tokens: candidate_tokens).(:refresh)
    end
  end


  def tokenize
    @sentence = get_sentence params[:sentence_id]#Sentence.find params[:sentence_id]

    @sentence.setup_tokenizer

    @words = Word.includes(:definitions).all
    @candidate_tokens = get_candidate_tokens @sentence.untokenized
  end

  def add_token
    sentence = get_sentence params[:sentence_id]#Sentence.find params[:sentence_id]
    word = Word.find params[:word_id]

    sentence.setup_tokenizer

    if sentence.untokenized.present? or sentence.untokenized =~ /^#{word.simplified}/
      token_sort_order = sentence.tokens.size == 0 ? 0 : sentence.tokens.map(&:sort_order).max + 1
      token = Token.create sentence: sentence, word: word, sort_order: token_sort_order
      sentence.reload
      sentence.untokenized.slice! token.word.simplified
      candidate_tokens = get_candidate_tokens sentence.untokenized

      render js: concept("sentence/sentence_cell/tokenize", sentence, candidate_tokens: candidate_tokens, current_user: current_user).(:refresh)
    else
      candidate_tokens = get_candidate_tokens sentence.untokenized
      flash[:alert] = "Error adding token. Token word didn't match untokenized text."
      render js: "window.location = '#{tokenize_sentence_path(sentence)}'"
      return
    end

  end

  def untokenize
    sentence = get_sentence params[:sentence_id]
    sentence.tokens.delete_all
    sentence.setup_tokenizer
    candidate_tokens = get_candidate_tokens sentence.untokenized
    render js: concept("sentence/sentence_cell/tokenize", sentence,
      current_user: current_user,
      candidate_tokens: candidate_tokens,
      current_user: current_user).(:refresh)
  end

  def remove_last_token
    sentence = get_sentence params[:sentence_id]
    sentence.tokens.order("sort_order desc").first.delete
    sentence.setup_tokenizer
    candidate_tokens = get_candidate_tokens sentence.untokenized
    render js: concept("sentence/sentence_cell/tokenize", sentence,
      current_user: current_user,
      candidate_tokens: candidate_tokens).(:refresh)
  end

  def show_tokenize_cell
    sentence = get_sentence params[:sentence_id]
    sentence.setup_tokenizer
    candidate_tokens = get_candidate_tokens sentence.untokenized
    render js: concept("sentence/sentence_cell/tokenize", sentence,
      current_user: current_user,
      candidate_tokens: candidate_tokens).(:show_tokenize_cell)
  end

  def show_manage_cell
    sentence = get_sentence params[:sentence_id]

    render js: concept("sentence/sentence_cell/manage", sentence,
      current_user: current_user).(:show_manage_cell)
  end

  def retranslate
    sentence = get_sentence params[:sentence_id]
    sentence.retranslate force_translation: true
    render js: concept("sentence/sentence_cell/manage", sentence,
      current_user: current_user).(:refresh)
  end

  private

  def get_candidate_tokens untokenized

    matches = []
    return matches unless untokenized.present?

    potential_matches = untokenized.empty? ? [] : Word.includes(:definitions).where("simplified LIKE :prefix", prefix: "#{untokenized[0]}%")
    potential_matches.each do |word|
      matches << word if word.simplified == untokenized[0...word.simplified.length]
    end
    if matches.empty?
      if untokenized[/^([a-zA-Z0-9_.-]*)/,1].length > 0
        word = Word.includes(:definitions).find_or_create_by simplified: untokenized[/^([a-zA-Z0-9_.-]*)/,1], type: :alphanumeric
      else
        word = Word.includes(:definitions).find_or_create_by simplified: untokenized[0], type: :alphanumeric
      end
      matches << word
    end
    return matches.sort_by { |y| -y.simplified.length} # TODO: add sort by how often it's used in the site.
  end

  def get_sentence id
    Sentence.includes(
      { words: [:definitions] },
      :source
    ).find(id)
  end

  def get_word id
    Word.includes(:definitions).find(id)
  end
end
