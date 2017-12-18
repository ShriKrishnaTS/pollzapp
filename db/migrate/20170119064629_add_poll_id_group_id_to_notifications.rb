class AddPollIdGroupIdToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :poll_id, :integer
    add_column :notifications, :group_id, :integer
  end
end
