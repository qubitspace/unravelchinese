class Definition < ActiveRecord::Base
  include Taggable
  belongs_to :word
end
