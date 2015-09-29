class Section < ActiveRecord::Base
  after_destroy :cleanup
  enum container: { block: 0, inline: 1, float_left: 2, float_right: 3 }
  enum alignment: { left: 0, center: 1, right: 2 }

  belongs_to :article
  #has_many :photos #can I do this?
  belongs_to :resource, polymorphic: true

  # These are not magic, they will match on the id and ignore the type...
  belongs_to :sentence, foreign_key: 'resource_id', class_name: 'Sentence'
  belongs_to :snippet, foreign_key: 'resource_id', class_name: 'Snippet'
  belongs_to :photo, foreign_key: 'resource_id', class_name: 'Photo'
  belongs_to :iframe, foreign_key: 'resource_id', class_name: 'Iframe'

  #validates :resource_type, presence: true
  #validates :resource_id, presence: true

  def set_sort_order article, sort_order = nil

    if sort_order.present?
      self.sort_order = sort_order
      shift_sections = article.sections.where( "sort_order > ?", sort_order).order( 'sort_order desc')
      shift_sections.each do |section|
        section.sort_order += 1
        section.save
      end
    else
      self.sort_order = if article.sections.count > 0
                        then article.sections.maximum(:sort_order) + 1
                        else 0
                        end
    end

  end

  private

  def cleanup
    if ['Sentence','Snippet'].include? self.resource_type
      self.resource.destroy
    end
  end

end
