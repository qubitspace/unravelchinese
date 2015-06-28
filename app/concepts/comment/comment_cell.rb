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

  # Move this to /trb/current_user.rb

  # def current_user # could be used in the view
  #   @options[:current_user]
  # end

  class CommentGrid < Cell::Concept
    inherit_views Comment::Cell

    include Kaminari::Cells
    include ActionView::Helpers::JavaScriptHelper

    def show
      # concept( "comment/comment_cell", paginated_options) + paginate(paginated_options[:collection])
      # concept( "comment/comment_cell", paginated_options) + link_to_next_page(paginated_options[:collection], 'Next Page') #paginate(paginated_options[:collection])
      render :comment_grid
    end

    def append
      %{ $("#next").replaceWith("#{j(show)}") }
    end

  private
    def page
      options[:page] or 1
    end

    def comments
      @comments ||= model.comments.page(page).per(3)
    end
  end
end