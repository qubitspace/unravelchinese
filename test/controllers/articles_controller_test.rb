require 'test_helper'

#include Monban::Test::ControllerHelpers
#include Warden::Test::Helpers


describe ArticlesController do

  let (:article) do
    article = Article::Create[article: {name: "Rails"}].model

    # Comment::Create[comment: {body: "Excellent", weight: "0", user: {email: "zavan@trb.org"}}, id: article.id]
    # Comment::Create[comment: {body: "!Well.", weight: "1", user: {email: "jonny@trb.org"}}, id: article.id]
    # Comment::Create[comment: {body: "Cool stuff!", weight: "0", user: {email: "chris@trb.org"}}, id: article.id]
    # Comment::Create[comment: {body: "Improving.", weight: "1", user: {email: "hilz@trb.org"}}, id: article.id]

    article
  end

  describe "#new" do
    it "#new [HTML]" do
      #Warden.test_mode!
      user = User.first
      #login_as(user, :scope => :user)
      sign_in(user)

      # TODO: please make Capybara matchers work with this!
      get :new
      assert_select "form #article_title"
    end
  end

  # describe "#create" do
  #   it do
  #     @test = true
  #     @current_user = User.create! email: 'user@mail.com', username: 'qubitspace', password_digest: 'password'
  #     login_as @current_user, :scope => :user
  #     #sign_in @current_user
  #     post :create, {article: {name: "Bad Religion"}}
  #     assert_redirected_to article_path(Article.last)
  #   end

  #   # it do # invalid.
  #   #   post :create, {article: {name: ""}}
  #   #   assert_select ".error"
  #   # end
  # end

  # describe "#edit" do
  #   it do
  #     get :edit, id: article.id
  #     assert_select "form #article_name.readonly[value='Rails']"
  #   end
  # end

  # describe "#update" do
  #   it do
  #     put :update, id: article.id, article: {name: "Trb"}
  #     assert_redirected_to article_path(article)
  #     # assert_select "h1", "Trb"
  #   end

  #   it do
  #     put :update, id: article.id, article: {description: "bla"}
  #     assert_select ".error"
  #   end
  # end

  # describe "#show" do
  #   it do
  #     get :show, id: article.id
  #     response.body.must_match /Rails/

  #      # the form. this assures the model_name is properly set.
  #     assert_select "input.button[value=?]", "Create Comment"
  #     # make sure the user form is displayed.
  #     assert_select ".comment_user_email"
  #     # comments must be there.
  #     assert_select ".comments .comment"
  #   end
  # end

  # describe "#create_comment" do
  #   it "invalid" do
  #     post :create_comment, id: article.id,
  #       comment: {body: "invalid!"}

  #     assert_select ".comment_user_email.error"
  #   end

  #   it do
  #     post :create_comment, id: article.id,
  #       comment: {body: "That green jacket!", weight: "1", user: {email: "seuros@trb.org"}}

  #     assert_redirected_to article_path(article)
  #     flash[:notice].must_equal "Created comment for \"Rails\""
  #   end
  # end

  # describe "#next_comments" do
  #   it do
  #     xhr :get, :next_comments, id: article.id, page: 2

  #     response.body.must_match /zavan@trb.org/
  #   end
  # end
end