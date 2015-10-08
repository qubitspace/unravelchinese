class Token < ActiveRecord::Base
  default_scope { order('sort_order') }
  belongs_to :sentence
  belongs_to :word

  def simplified
    word.simplified
  end
end
