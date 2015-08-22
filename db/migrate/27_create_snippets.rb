class CreateSnippets < ActiveRecord::Migration
  def change
    create_table :snippets do |t|
      t.text :content
      t.integer :category, null: false

      t.timestamps null: false
    end
  end
end
