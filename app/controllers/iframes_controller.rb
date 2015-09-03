class IframesController < ApplicationController

  def index
    @iframes = Iframe.order(created_at: :desc).all
  end

  def manage
    @iframe = Iframe.find(params[:iframe_id])
  end

  def create
    display_type = params[:iframe][:display_type]
    form = Iframe::Form.new(Iframe.new)

    if form.validate(params[:iframe])
      form.save
      render js: concept("iframe/iframe_cell/#{display_type}", form.model, current_user: current_user).(:add_iframe)
    else
      render js: concept("iframe/iframe_form_cell/new", form, current_user: current_user, display_type: display_type).(:show)
    end
  end

  def update
    display_type = params[:iframe][:display_type]
    iframe = Iframe.find(params[:id])
    form = Iframe::Form.new(iframe)

    if form.validate(params[:iframe])
      form.save
      render js: concept("iframe/iframe_cell/#{display_type}", iframe, current_user: current_user, display_type: display_type).(:refresh_iframe)
    else
      render js: concept("iframe/iframe_form_cell/edit", form, current_user: current_user, display_type: display_type).(:show)
    end
  end

  def destroy
    iframe = Iframe.find(params[:id])
    iframe.destroy

    if params[:display_type] == 'manage'
      render :js => "window.location = '#{iframes_path}'"
    else
      render js: concept("iframe/iframe_cell", iframe).(:remove_iframe)
    end
  end

  def show_new_form
    form = Iframe::Form.new(Iframe.new)
    render js: concept("iframe/iframe_form_cell/new", form, current_user: current_user, display_type: params[:display_type]).(:show)
  end

  def show_edit_form
    iframe = Iframe.find(params[:iframe_id])
    form = Iframe::Form.new(iframe)
    render js: concept("iframe/iframe_form_cell/edit", form, current_user: current_user, display_type: params[:display_type]).(:show)
  end

  def cancel_edit_form
    display_type = params[:display_type]
    iframe = Iframe.find(params[:iframe_id])
    render js: concept("iframe/iframe_cell/#{display_type}", iframe, current_user: current_user).(:refresh_iframe)
  end

end
