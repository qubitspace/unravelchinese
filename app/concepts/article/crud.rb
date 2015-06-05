#require 'trailblazer/operation/crud'

class Article < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include CRUD

    model Article, :create

    contract do
      model Article # this will be infered in the next trb release.

      property :link
      property :title
      property :description
      property :published
      property :commentable

      property :source do
        property :path
        property :name
        validates :name, presence: true
      end

      validates :link, presence: true
      validates :title, presence: true

      validates :description, length: {in: 4..160}, allow_blank: true
    end

    def process(params)
      validate(params[:article]) do |p|
        p.save
        # raise f.author.inspect
      end

      # def setup_model!(params)
      #   model.build_source
      # end
    end
  end

  class Update < Create
    action :update

    # example of skipping an inherited callback
    # skip :check_spelling!

    # def setup_model!(params)
    # end

    # contract do
    #   property :title, writeable: false
    # end
  end
end