class CreateTranslations < ActiveRecord::Migration
  def change
    create_table :translations do |t|
      t.text :value, :null => false
      t.references :source, index: true
      t.references :user, index: true
      t.references :sentence, index: true

      t.timestamps null: false
    end
    add_foreign_key :translations, :sources
    add_foreign_key :translations, :users
    add_foreign_key :translations, :sentences
  end
end
