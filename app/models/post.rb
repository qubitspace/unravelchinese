class Post < ActiveRecord::Base
   has_many :attachments
   has_many :documents, through: :attachments, as: :attachable
end
