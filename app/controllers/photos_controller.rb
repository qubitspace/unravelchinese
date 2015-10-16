class PhotosController < ApplicationController
  include Concerns::Manageable

  skip_before_filter  :verify_authenticity_token, only: [:create, :update]

  def index
    authorize Photo
    @photos = Photo.order(created_at: :desc).all
  end

  def manage
    @photo = Photo.find(params[:photo_id])
    authorize @photo
  end

end
