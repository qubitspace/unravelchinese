module Concerns
  module Manageable
    extend ActiveSupport::Concern

    def create
      authorize model_class
      display_type = params[:"#{model_type}"][:display_type]
      form = model_class::Form.new(model_class.new)

      if form.validate(params[:"#{model_type}"])
        form.save
        render js: concept("#{model_type}/#{model_type}_cell/#{display_type}", form.model, current_user: current_user).(:prepend)
      else
        render js: concept("#{model_type}/#{model_type}_form_cell", form, current_user: current_user, display_type: display_type).(:show_new_form)
      end
    end

    def update
      authorize model_class
      display_type = params[:"#{model_type}"][:display_type]
      model = model_class.find(params[:id])
      form = model_class::Form.new(model)

      if form.validate(params[:"#{model_type}"])
        form.save
        render js: concept("#{model_type}/#{model_type}_cell/#{display_type}", form.model, current_user: current_user, display_type: display_type).(:refresh)
      else
        render js: concept("#{model_type}/#{model_type}_form_cell", form, current_user: current_user, display_type: display_type).(:show_edit_form)
      end
    end

    def destroy
      authorize model_class
      model = model_class.find(params[:id])
      model.destroy

      if ['show', 'manage'].include? params[:display_type] and !['section'].include? model_type
        link_method = self.method(:"#{model_type.pluralize}_path")
        render :js => "window.location = '#{link_method.call}'"
      else
        render js: concept("#{model_type}/#{model_type}_cell", model).(:remove)
      end
    end

    def show_new_form
      authorize model_class
      form = model_class::Form.new(model_class.new)
      render js: concept("#{model_type}/#{model_type}_form_cell", form, current_user: current_user, display_type: params[:display_type]).(:show_new_form)
    end

    def cancel_new_form
      authorize model_class
      form = model_class::Form.new(model_class.new)
      render js: concept("#{model_type}/#{model_type}_form_cell", form, current_user: current_user).(:cancel_new_form)
    end

    def show_edit_form
      authorize model_class
      model = model_class.find(params[:"#{model_type}_id"])
      form = model_class::Form.new(model)
      render js: concept("#{model_type}/#{model_type}_form_cell", form, current_user: current_user, display_type: params[:display_type]).(:show_edit_form)
    end

    def cancel_edit_form
      authorize model_class
      display_type = params[:display_type]
      model = model_class.find(params[:"#{model_type}_id"])
      render js: concept("#{model_type}/#{model_type}_cell/#{display_type}", model, current_user: current_user).(:refresh)
    end

    private

    def model_class
      self.class.to_s.sub("Controller", "").singularize.constantize
    end

    def model_type
      self.class.to_s.sub("Controller", "").singularize.downcase
    end

  end
end