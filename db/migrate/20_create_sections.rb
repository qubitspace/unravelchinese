class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.references :article
      t.references :resource, polymorphic: true
      t.integer :sort_order
      t.integer :container
      t.integer :alignment

      t.timestamps null: false
    end
  end
end
