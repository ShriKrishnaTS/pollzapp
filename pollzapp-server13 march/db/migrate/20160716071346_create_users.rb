class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name, limit: 64
      t.string :username, unique: true, limit: 64
      t.string :phone, unique: true, limit: 20
      t.string :otp_secret_key
      t.string :image
      t.string :auth_token, limit: 64
      t.boolean :notifications_enabled, default: true, null: false
      t.integer :language, limit: 1, default: 0, null: false

      t.timestamps
    end
  end
end
