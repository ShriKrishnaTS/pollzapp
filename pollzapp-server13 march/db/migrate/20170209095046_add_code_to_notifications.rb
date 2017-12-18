class AddCodeToNotifications < ActiveRecord::Migration[5.0]
  def change
add_column :notifications, :code, :string
  end
end
