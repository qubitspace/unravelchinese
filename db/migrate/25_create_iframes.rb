class CreateIframes < ActiveRecord::Migration
  def change
    create_table :iframes do |t|
      t.references :source
      t.string :url
      t.string :title

      t.timestamps null: false
    end
  end
end
