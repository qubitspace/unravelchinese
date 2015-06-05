require 'test_helper'

class ArticleCrudTest < MiniTest::Spec
  describe "Create" do
    it "persists valid" do
      article = Article::Create[article: {
          link: "www.test.com",
          title: "My Shiny Article",
          description: "Has chinese"
        }].model
      article.persisted?.must_equal true
      article.link.must_equal "www.test.com"
      article.title.must_equal "My Shiny Article"
      article.description.must_equal "Has chinese"
      article.published.must_equal false
      article.commentable.must_equal true
    end

    it "invalid" do
      result, operation = Article::Create.run(article: {link: "", title: ""})

      result.must_equal false
      operation.errors.to_s.must_equal "{:link=>[\"can't be blank\"], :title=>[\"can't be blank\"]}"
      operation.model.persisted?.must_equal false
    end

  end

  describe "Update" do
    let (:article) {
      Article::Create[article: {
          link: "www.test.com",
          title: "My Shiny Article",
          description: "Has chinese"
        }].model
    }

    it "persists valid, ignores name" do
      Article::Update[
        id:     article.id,
        article: {
          link: "www.test2.com",
          title: "My New Shiny Article"
        }].model

      article.reload
      article.link.must_equal "www.test2.com"
      article.title.must_equal "My New Shiny Article"
      article.description.must_equal "Has chinese"
    end
  end
end
