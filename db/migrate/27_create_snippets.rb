class CreateSnippets < ActiveRecord::Migration
  def change
    create_table :snippets do |t|
      t.text :content
      t.integer :format #redcloth, html, raw, etc...

      t.timestamps null: false
    end
  end
end
