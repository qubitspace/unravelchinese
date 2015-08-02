class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :source
      t.string :file
      t.string :title
      t.string :type

      t.timestamps null: false
    end
  end
end
