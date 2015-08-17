class Image::ImageCell < Cell::Concept

  property :id
  property :file
  property :title
  property :created_at

  property :source_id
  property :source do
    property :id
    property :link
    property :name
  end

  include Cell::CreatedAt

  def show
    render :show_image
  end

  private

  def current_user # could be used in the view
    @options[:current_user]
  end


  class ManageImageCell < Image::ImageCell
    def show
      render :manage_image
    end
  end

end

