class Section < ActiveRecord::Base
  default_scope { order('sort_order') }
  after_destroy :cleanup
  enum container: { block: 0, inline: 1, float_left: 2, float_right: 3 }
  enum alignment: { left: 0, center: 1, right: 2 }
  serialize :token_offsets, Array

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

  def is_clone
    @is_clone
  end

  def is_clone= is_clone
    @is_clone = is_clone
  end

  def set_sort_order article, sort_order = nil
    if sort_order.present?
      self.sort_order = sort_order
      shift_sections = article.sections.where( "sort_order >= ?", sort_order).order( 'sort_order desc')

      # TODO: Just use a sql statment to do all the updates at once.
      shift_sections.each do |section|
        section.sort_order += 1
        section.save
      end
    else
      # just use article.next_sort_order...
      self.sort_order = if article.sections.count > 0
                        then article.sections.maximum(:sort_order) + 1
                        else 0
                        end
    end
  end


  def move_down
    next_section = self.article.sections.where( "sort_order = ?", sort_order + 1 ).first
    if next_section.present?
      ActiveRecord::Base.transaction do
        next_section.sort_order = self.sort_order
        next_section.save

        self.sort_order = self.sort_order + 1
        self.save
      end
    end
    return next_section
  end

  def move_up
    prev_section = self.article.sections.where( "sort_order = ?", sort_order - 1 ).first
    if prev_section.present?
      ActiveRecord::Base.transaction do
        prev_section.sort_order = self.sort_order
        prev_section.save

        self.sort_order = self.sort_order - 1
        self.save
      end
    end
    return prev_section
  end

  private

  def cleanup
    if ['Sentence','Snippet'].include? self.resource_type
      self.resource.destroy
    end
  end

end
