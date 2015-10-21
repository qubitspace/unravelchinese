class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.references :article
      t.references :resource, polymorphic: true
      t.integer :sort_order
      t.integer :container, null: false, default: 0
      t.integer :alignment, null: false, default: 0
      t.boolean :end_paragraph
      t.float :start_time
      t.float :end_time
      t.text :token_offsets

      t.timestamps null: false
    end
  end
end
