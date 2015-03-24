class CreateLearnedWords < ActiveRecord::Migration
  def change
    create_table :learned_words do |t|
      t.references :user, null: false, index: true
      t.references :word, null: false, index: true
      t.integer :status

      t.timestamps null: false
    end
    add_foreign_key :learned_words, :users
    add_foreign_key :learned_words, :words
  end
end
