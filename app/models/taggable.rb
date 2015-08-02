module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, :as => :taggable, dependent: :destroy
    has_many :tags, :through => :taggings
  end

  def tag(name)
    # TODO: Validate that taggable_type is valid...
    name.strip!
    tag = Tag.find_or_create_by name: name
    self.taggings.find_or_create_by taggable_type: self.taggable_type, tag_id: tag.id
  end

  def tag_names
    tags.collect(&:name)
  end
end