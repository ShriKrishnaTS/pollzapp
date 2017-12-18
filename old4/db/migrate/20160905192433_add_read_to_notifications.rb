class AddReadToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :read, :boolean, default: false, null: false
  end
end
