class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.references :attachable, polymorphic: true
      t.references :document
      t.string :orientation
      t.string :span

      t.timestamps null: false
    end
  end
end
