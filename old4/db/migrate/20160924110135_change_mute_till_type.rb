class ChangeMuteTillType < ActiveRecord::Migration[5.0]
  def change
  		remove_column :group_users, :mute_till, :boolean, default: false, null: false
  		add_column :group_users, :mute_till, :datetime
  end
end
