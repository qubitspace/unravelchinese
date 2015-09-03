class CreateSentences < ActiveRecord::Migration
  def change
    create_table :sentences do |t|
      t.text :value, null: false
      t.boolean :translatable, null: false, default: false
      t.boolean :auto_translate, null: false, default: false

      t.timestamps null: false
    end

  end
end
