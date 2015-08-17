class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :source
      t.string :file
      t.string :title
      t.text :description

      t.timestamps null: false
    end
  end
end
# TODO: add a link to the site where this image is from? Just add a source or a link to the specific location?