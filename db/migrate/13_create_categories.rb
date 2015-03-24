class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.references :article, index: true
      t.references :parent, index: true

      t.string :name, index: true

      t.timestamps null: false
    end

  end
end