class CreateSentences < ActiveRecord::Migration
  def change
    create_table :sentences do |t|
      t.references :source, index: true
      t.text :value, null: false

      t.timestamps null: false
    end

    add_foreign_key :sentences, :articles
    add_foreign_key :sentences, :sources
  end
end
