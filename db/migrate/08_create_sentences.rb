class CreateSentences < ActiveRecord::Migration
  def change
    create_table :sentences do |t|
      t.references :source, index: true
      t.references :article, null: false, index: true
      t.integer :rank, null: false
      t.text :value, null: false
      t.boolean :end_paragraph

      t.timestamps null: false
    end

    add_index :sentences, [:article_id, :rank], unique: true
    add_foreign_key :sentences, :articles
    add_foreign_key :sentences, :sources
  end
end
