class Sentence::SentenceCell < Cell::Concept

  property :id
  property :value
  property :rank
  property :end_paragraph

  property :article
  property :words
  property :translations
  property :tokens


  def show
    render :sentence_show
  end

  private

  def current_user
    @options[:current_user]
  end


end
