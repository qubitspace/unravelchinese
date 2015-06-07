class Comment < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include CRUD
    model Comment, :create

    contract do
      # what does this do?
      include Reform::Form::ModelReflections
      reform_2_0!

      # def self.weights
      #   {"0" => "Nice!", "1" => "Rubbish!"}
      # end

      # def weights
      #   [self.class.weights.to_a, :first, :last]
      # end

      property :body
      property :article

      validates :body, length: { in: 6..160 }

    end


    def process(params)
      validate(params[:comment]) do |f|
        f.save # save comment and user.

        # callbacks go here!
        # check_spelling!
        # OR
        # dispatch :check_spelling!
      end
    end


    def article
      model.article
    end


  private
    def setup_model!(params)
      model.article = Article.find_by_id(params[:id])
    end
  end
end
