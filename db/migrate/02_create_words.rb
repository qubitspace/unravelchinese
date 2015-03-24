class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.integer :category, null: false, index: true
      t.string :simplified, null: false, index: true
      t.string :traditional, index: true
      t.string :pinyin, index: true
      t.string :pinyin_cs, index: true
      t.integer :hsk_character_level, index: true
      t.integer :hsk_word_level, index: true
      t.integer :character_frequency, index: true
      t.integer :word_frequency, index: true
      t.integer :radical_number, index: true
      t.integer :strokes, index: true
      t.integer :radical_number, index: true

      t.timestamps null: false
    end
  end

end
