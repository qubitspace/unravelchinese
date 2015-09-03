class ImagesController < ApplicationController
  #skip_before_filter  :verify_authenticity_token, only: [:create]
  def index
    @images = Image.order(created_at: :desc).all
  end

  def manage
    @image = Image.find(params[:image_id])
  end

  def create
    display_type = params[:image][:display_type]
    form = Image::Form.new(Image.new)

    if form.validate(params[:image])
      form.save
      render js: concept("image/image_cell/#{display_type}", form.model, current_user: current_user).(:add_image)
    else
      render js: concept("image/image_form_cell/new", form, current_user: current_user, display_type: display_type).(:show)
    end
  end

  def update
    display_type = params[:image][:display_type]
    image = Image.find(params[:id])
    form = Image::Form.new(image)

    if form.validate(params[:image])
      form.save
      render js: concept("image/image_cell/#{display_type}", image, current_user: current_user, display_type: display_type).(:refresh_image)
    else
      render js: concept("image/image_form_cell/edit", form, current_user: current_user, display_type: display_type).(:show)
    end
  end

  def destroy
    image = Image.find(params[:id])
    image.destroy

    if params[:display_type] == 'manage'
      render :js => "window.location = '#{images_path}'"
    else
      render js: concept("image/image_cell", iframe).(:remove_image)
    end
  end

  def show_new_form
    form = Image::Form.new(Image.new)
    render js: concept("image/image_form_cell/new", form, current_user: current_user, display_type: params[:display_type]).(:show)
  end

  def show_edit_form
    image = Image.find(params[:image_id])
    form = Image::Form.new(image)
    render js: concept("image/image_form_cell/edit", form, current_user: current_user, display_type: params[:display_type]).(:show)
  end

  def cancel_edit_form
    display_type = params[:display_type]
    iframe = Image.find(params[:iframe_id])
    render js: concept("image/image_cell/#{display_type}", image, current_user: current_user).(:refresh_image)
  end

end
