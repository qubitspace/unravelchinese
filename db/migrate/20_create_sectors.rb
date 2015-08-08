class CreateSectors < ActiveRecord::Migration
  def change
    create_table :sectors do |t|
      t.references :article
      t.references :resource, polymorphic: true
      t.integer :rank

      t.timestamps null: false
    end
  end
end
