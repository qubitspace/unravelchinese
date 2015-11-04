class Word::Form < Reform::Form

  property :category, validates: { presence: true }
  property :simplified, validates: { presence: true }
  property :traditional, validates: { presence: true }
  property :pinyin, validates: { presence: true }
  property :hsk_character_level
  property :hsk_word_level
  property :character_frequency
  property :word_frequency
  property :radical_number
  property :strokes

  # Instead of using the :all_blank macro for the :skip_if option, I instruct Reform to call the instance method skip_user?
  # This method is called per incoming nested definition hash when the params are deserialized in validate.
  collection :definitions, skip_if: :skip_user?, populate_if_empty: lambda { |fragment, args| Definition.new } do
    property :value, validates: { presence: true }
    property :sort_order, validates: { presence: true }
    property :remove, virtual: true

    def removeable?
      model.persisted?
    end
  end

  def skip_user?(fragment, options)
    if fragment["remove"] == "1"
      definitions.delete(definitions.find { |d| d.id.to_s == fragment["id"] })
      return true
    end
  end




end
