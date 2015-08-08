class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :source
      t.string :file
      t.string :format
      t.string :title
      s.text :description

      t.timestamps null: false
    end
  end
end
