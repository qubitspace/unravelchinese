class Token < ActiveRecord::Base
  belongs_to :sentence
  belongs_to :word

  def simplified
    word.simplified
  end
end
