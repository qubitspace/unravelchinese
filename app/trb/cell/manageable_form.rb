module Cell
  module ManageableForm
    def self.included(base)
      base.send(:include, ActionView::RecordIdentifier)
      base.send(:include, ActionView::Helpers::FormHelper)
      base.send(:include, ActionView::Helpers::FormOptionsHelper)
      base.send(:include, NestedForm::ViewHelper)
      base.send(:include, ActionView::Helpers::JavaScriptHelper)
    end

    def show
      render :"add_#{model_type}_form"
    end

    private

    def model_type
      model.class.to_s.split(':')[0].downcase
    end

    def display_type
      @options[:display_type]
    end

    def cancel_link
      link_to "Cancel", cancel_form_path, remote: true, method: :put
    end

    def cancel_form_path
      if is_new_form?
        send(:"cancel_new_form_#{model_type.pluralize}_path", display_type)
      else
        send(:"#{model_type}_cancel_edit_form_path", model, display_type)
      end
    end

    def show_edit_form
      %{
        $('.#{model_type}.#{display_type}[#{model_type}-id="#{id}"]').each(function() {
          $(this).replaceWith('#{j(render (model_type + '_form').to_sym)}');
        });
      }
    end

    def show_new_form
      %{
        $('.#{model_type}[#{model_type}-id="new"]').remove();
        $('.#{model_type.pluralize}').prepend('#{j(render (model_type + '_form').to_sym)}');
      }
    end

    def cancel_new_form
      %{
        $('.#{model_type}[#{model_type}-id="new"]').remove();
      }
    end

    def id
      model.id || 'new'
    end

    def is_new_form?
      model.id.nil?
    end

    def is_edit_form?
      model.id.present?
    end

  end


end

