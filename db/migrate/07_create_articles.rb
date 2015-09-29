class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.references :source, index: true
      t.references :category, index: true
      t.references :iframe
      t.references :photo

      t.text :title, null: false
      t.text :description
      t.text :content_source_link
      t.text :content_source_name
      t.text :translation_source_link
      t.text :translation_source_name

      t.boolean :published, null: false, default: false
      t.boolean :commentable, null: false, default: true

      t.timestamps null: false
    end

    add_foreign_key :articles, :sources
    add_foreign_key :articles, :categories
  end
end
