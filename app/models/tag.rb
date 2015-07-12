class Tag < ActiveRecord::Base
  has_many :taggings, dependent: :destroy
  has_many :words, through: :taggings, source: :taggable, source_type: Word
  has_many :articles, through: :taggings, source: :taggable, source_type: Article

  def self.with_taggable_count options = {}
    options[:count]       ||= 100
    options[:page]        ||= 0
    options[:type]        ||= 'Word'
    options[:query]       ||= nil

    tags = Tag.select("tags.id, tags.name, taggings.taggable_type, count(taggings.taggable_id) AS taggable_count")
      .joins('inner join taggings on tags.id = taggings.tag_id')
      .group("tags.id, tags.name, taggings.taggable_type")
      .having('taggings.taggable_type = ?', options[:type])
      .order('taggable_count desc')
      .offset(5)
      .limit(options[:count])

    tags = tags.where('name like ?', "%#{options[:query]}%") if options[:query].present?
    return tags
  end

end
