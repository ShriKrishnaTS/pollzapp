class AddUserNameToNotificatioins < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :name, :string
    add_column :notifications, :username, :string
    add_column :notifications, :image, :string
   
  end
end
