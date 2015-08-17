class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.references :article
      t.references :resource, polymorphic: true
      t.integer :rank
      t.string :classes

      t.timestamps null: false
    end
  end
end
