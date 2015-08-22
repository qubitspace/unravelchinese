class Iframe::IframeCell < Cell::Concept
  property :url
  property :title
  property :description
  property :created_at

  include Cell::CreatedAt
  def show
    render :show_iframe
  end

  def nested
    render :nested_iframe
  end

  private

  def current_user # could be used in the view
    @options[:current_user]
  end

  class ManageIframeCell < Iframe::IframeCell
    def show
      render :manage_iframe
    end
  end


end

