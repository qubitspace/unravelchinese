class Comment::CommentGridCell < Cell::Concept
  inherit_views Comment::CommentCell

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
    @comments ||= model.comments.page(page).per(10)
  end
end