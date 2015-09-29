class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :file
      t.string :title
      t.string :source_name
      t.string :source_link
      t.text :description

      t.timestamps null: false
    end
  end
end