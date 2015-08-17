class Section < ActiveRecord::Base
  after_destroy :cleanup

  belongs_to :article
  #has_many :images #can I do this?
  belongs_to :resource, polymorphic: true

  validates :resource_id, presence: true
  # Sentences and Snippets can't be shared between sections.
  validates :resource_id, :uniqueness => { :scope => [:resource_type, :resource_id] }, if: lambda { |section| ['Sentence','Snippet'].include? section.resource_type }

  private
  def cleanup
    if ['Sentence','Snippet'].include? self.resource_type
      self.resource.destroy
    end
  end

end
