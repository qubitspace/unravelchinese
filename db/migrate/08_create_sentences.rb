class CreateSentences < ActiveRecord::Migration
  def change
    create_table :sentences do |t|
      t.references :source, index: true
      t.text :value, null: false
      t.boolean :translatable, null: false, default: false
      t.boolean :auto_translate, null: false, default: false

      t.timestamps null: false
    end

    add_foreign_key :sentences, :sections
    add_foreign_key :sentences, :sources
  end
end
