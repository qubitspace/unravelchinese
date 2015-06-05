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
      #property :weight
      #property :thing

      validates :body, length: { in: 6..160 }
      #validates :weight, inclusion: { in: weights.keys }
      validates :article, :user, presence: true

      property :user do
        property :email
        #validates :email, presence: true, email: true
      end

      def weight
        super or "0"
      end
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
      #model.build_user
    end
  end
end
