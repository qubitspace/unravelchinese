class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.integer :review_id
      t.string :name, null: false
      t.string :link, unique: true
      t.boolean :disabled, default: false
      t.boolean :restricted, default: false

      t.timestamps null: false
    end

    add_index :sources, :name, unique: true
  end
end