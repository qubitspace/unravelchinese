class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :email, null: false
      t.string :username, null: false
      t.string :password_digest, null: false
      t.boolean :email_confirmed
      t.string :confirm_token

      # Roles
      t.integer :role, null: false

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
  end
end
