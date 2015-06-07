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
        property :link
        property :name
        validates :link, presence: true
        validates :name, presence: true
      end

      # Reform comes with an option :prepopulator that is designed to solve the above dilemma
      # prepopulate the form before it’s rendered.
      # property :user, prepopulator: ->(*) { self.user = User.new } do
      #   property :email
      # end

      # The :populate_if_empty option has a different behavior: It knows about the incoming hash
      # and about the existing model(s) in the nested form(s). The block is only run when there is an
      # incoming hash, but no corresponding nested form.
      # property :user, prepopulator: ->(*) { self.user = User.new }, populate_if_empty: ->(*) { User.new } do
      #   property :email
      # end

      validates :link, presence: true
      validates :title, presence: true

      validates :description, length: {in: 4..160}, allow_blank: true
    end

    builds ->(params) do
      user = params[:current_user]
      return Create if user.admin?
      deny!
    end

    def current_user # could be used in the view
      @options[:current_user]
    end

    def process(params)
      validate(params[:article]) do |p|
        p.save
        # raise f.author.inspect
      end

    end

    #This hook is run directly before process is invoked, but after the generic model was created
    def setup_model!(params)
      model.build_source
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