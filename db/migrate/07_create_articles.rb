class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.references :source, index: true
      t.references :category, index: true
      t.text :link
      t.text :title, null: false
      t.text :description
      t.boolean :published, null: false, default: false
      t.boolean :commentable, null: false, default: true

      t.timestamps null: false
    end

    add_foreign_key :articles, :sources
    add_foreign_key :articles, :categories
  end
end
