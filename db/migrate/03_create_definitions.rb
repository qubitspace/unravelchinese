class CreateDefinitions < ActiveRecord::Migration
  def change
    create_table :definitions do |t|
      t.references :word, null: false, index: true
      t.text :value
      t.integer :rank, index: true

      t.timestamps null: false
    end
    add_foreign_key :definitions, :words
  end
end
