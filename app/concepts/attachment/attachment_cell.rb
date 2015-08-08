class Attachment::AttachmentCell < Cell::Concept
  property :attachable
  property :document
  property :id

  def show
    render :show
  end


  private


  def current_user
    @options[:current_user]
  end


  class ManageAttachmentCell < Attachment::AttachmentCell

    def show
      render :manage_attachment
    end

    private

    def delete_attachment_link
      link_to 'Delete', taggable_untag_path(taggable, taggable.taggable_type, model), method: :post, remote: true
    end

  end

end