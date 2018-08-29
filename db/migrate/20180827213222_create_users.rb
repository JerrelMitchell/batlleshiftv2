class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.integer :status, default: 0
      t.string :auth_token
      t.string :activation_token

      t.timestamps
    end
    add_index :users, :auth_token, unique: true
    add_index :users, :activation_token, unique: true
  end
end
