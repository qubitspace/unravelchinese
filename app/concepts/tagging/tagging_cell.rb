class Tagging::TaggingCell < Cell::Concept
  property :tag
  property :taggable
  property :id

  def show
    render :show
  end

  private

  def remove_tag_link
    link_to 'Untag', taggable_untag_path(taggable, taggable.taggable_type, model), method: :post, remote: true
  end

  def current_user
    @options[:current_user]
  end


  class ManageTaggingCell < Tagging::TaggingCell

    def show
      render :manage_tagging
    end
  end

end