class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.references :sentence, null: false, index: true
      t.references :word, null: false, index: true
      t.integer :rank

      t.timestamps null: false
    end

    add_index :tokens, [:sentence_id, :rank], unique: true
    add_foreign_key :tokens, :sentences
    add_foreign_key :tokens, :words
  end
end