class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true
  belongs_to :document
  enum orientation: [:left, :center, :right]
  enum span: [:float, :fill, :default]
end
