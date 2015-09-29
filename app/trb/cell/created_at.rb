module Cell
  module CreatedAt
    def self.included(base)
      base.send :include, ActionView::Helpers::DateHelper
      base.send :include, Rails::Timeago::Helper
      base.property :created_at
    end

  private
    def created_at
      timeago_tag(super)
    end
  end
end