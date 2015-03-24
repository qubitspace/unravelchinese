class Tag < ActiveRecord::Base
  has_many :taggings, dependent: :destroy

  has_many :definitions, through: :taggings, source: :taggable, source_type: Definition
  has_many :words, through: :definitions

  has_many :articles, through: :taggings, source: :taggable, source_type: Article

  def self.with_word_count options = {}
    options[:count]       ||= 1000

    Tag.joins("inner join taggings on taggings.tag_id = tags.id
              inner join definitions on taggings.taggable_id = definitions.id and taggings.taggable_type = 'Definition'
              inner join words on definitions.word_id = words.id")
      .select("tags.name, tags.id, count(*) as word_count")
      .group('tags.id')
      .order('count(*) asc')
      .limit(options[:count])
  end

    # Find Notes:
    # find( :all,
    #     :limit => options[:count],
    #     :select => 'posts.id, posts.title, posts.state, posts.created_at,
    #     posts.photo_file_name, posts.photo_content_type, posts.photo_file_size,
    #     posts.photo_updated_at, tags.name, tags.taggable_id',
    #     :conditions => "tags.name IN (\"#{names*"\",\""}\") AND posts.id != #{post_id}",
    #     :include => 'tags',
    #     :group => 'tags.taggable_id',
    #     :having => 'COUNT(ratings.ratable_id) >= ' + options[:min].to_s,
    #     :order => 'count(tags.name) desc')

end
