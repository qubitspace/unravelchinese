module Cell
  module ManageableCell
    def self.included(base)
      base.send(:include, ActionView::Helpers::JavaScriptHelper)
      base.property :id
    end


    def show
      render (display_type + '_' + model_type).to_sym
    end

    def remove
      %{
        $('.#{model_type}[#{model_type}-id="#{id}"]').each(function() {
          $(this).remove();
        });
      }
    end

    def prepend
      %{
        $('.#{model_type}[#{model_type}-id="new"]').remove();
        $('.#{model_type.pluralize}').prepend('#{j(show)}');
      }
    end


    def append
      #$('##{model_type.pluralize}').append('#{j(render ('manage_' + model_type).to_sym)}');
      %{
        $('##{model_type.pluralize}').append('#{j(show)}');
      }
    end

    def refresh
      %{
        $('.#{model_type}.#{display_type}[#{model_type}-id="#{id}"]').each(function() {
          $(this).replaceWith('#{j(show)}');
        });
      }
    end

    private

    def display_type
      self.class.to_s.split(':').last.downcase
    end

    def model_type
      model.class.to_s.downcase
    end

    def current_user
      @options[:current_user]
    end

    def show_link
      link_to "Show", send(:"#{model_type}_path", model)
    end

    def manage_link
      link_to "Manage", send(:"#{model_type}_manage_path", model)
    end

    def edit_link
      link_to "Edit", show_edit_form_path, remote: true, method: :put
    end

    def delete_link
      link_to 'Delete', send(:"#{model_type}_path", model, display_type: display_type), remote: true, method: :delete, data: { confirm: "Permanently delete this #{model_type.titleize}?" }
    end

    def show_edit_form_path
      send(:"#{model_type}_show_edit_form_path", model, display_type)
    end

  end
end

