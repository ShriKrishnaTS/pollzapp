class AddUserImageToNotificatioins < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :user_image, :string
    add_column :notifications, :poll_title, :string
    add_column :notifications, :group_title, :string
    add_column :notifications, :creator_id, :string
    add_column :notifications, :link, :string
  end
end
