class AddLinkToRailsPushNotifications < ActiveRecord::Migration[5.0]
  def change
        add_column :rails_push_notifications_notifications, :link, :string
        add_column :rails_push_notifications_notifications, :creator_id, :integer
        add_column :rails_push_notifications_notifications, :group_id, :integer
        add_column :rails_push_notifications_notifications, :user_id, :integer



  end
end
