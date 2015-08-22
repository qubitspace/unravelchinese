class Translation < ActiveRecord::Base
  acts_as_votable
  belongs_to :sentence
  belongs_to :user
  enum category: [:primary, :user, :google, :bing]

  def self.display_categories
    self.categories.keys.to_a - ['google','bing']
  end

end