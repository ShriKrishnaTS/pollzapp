class AddDescriptioinToNotificatioins < ActiveRecord::Migration[5.0]
  def change
   add_column :notifications, :description, :string
  end
end
