class Comment::CommentCell < Cell::Concept
  property :created_at
  property :body
  property :definitions

  include Cell::GridCell
  include Cell::CreatedAt

  self.classes = ["comment", "large-4", "columns"]

  def show
    render :comment_show
  end

  private

end