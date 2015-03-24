class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|

      t.references :taggable, polymorphic: true
      t.references :tag
      t.timestamps null: false
    end
  end
end
