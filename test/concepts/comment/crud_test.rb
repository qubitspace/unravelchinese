class CommentCrudTest < MiniTest::Spec
  let (:article) { Article::Create[article: {name: "Ruby"}].model }

  describe "Create" do
    it "persists valid" do
      res, op = Comment::Create.run(
        comment: {
          body: "Fantastic!"#,
          #user: { email: "jonny@trb.org" }
        },
        id: article.id
      )
      comment = op.model

      comment.persisted?.must_equal true
      comment.body.must_equal "Fantastic!"
      comment.weight.must_equal 1

      comment.user.persisted?.must_equal true
      comment.user.email.must_equal "jonny@trb.org"
      op.article.must_equal article
    end
  end
end