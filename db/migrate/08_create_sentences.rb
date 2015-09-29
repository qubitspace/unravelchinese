class CreateSentences < ActiveRecord::Migration
  def change
    create_table :sentences do |t|
      t.text :value, null: false
      t.decimal :start_time
      t.decimal :end_time
      t.boolean :translatable, null: false, default: false
      t.boolean :auto_translate, null: false, default: false
      t.boolean :commentable, null: false, default: true
      t.boolean :has_traditional_characters, null: false, default: false

      t.timestamps null: false
    end

  end
end
