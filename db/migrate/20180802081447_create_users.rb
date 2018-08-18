class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :remember_digest
      t.string :reset_digest
      t.string :activation_digest
      t.integer :user_type, default: 0
      t.datetime :activated_at
      t.integer :activated
      t.boolean :blocked

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
