class SorceryCore < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email,            :null => false
      t.string :crypted_password
      t.string :salt
      t.string :auth_token
      t.date :token_expiration
      t.boolean :session_active
      t.integer :role_id

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
