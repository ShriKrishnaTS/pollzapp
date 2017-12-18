class AddMuteTillToGroupUser < ActiveRecord::Migration[5.0]
  def change
add_column :group_users, :mute_till, :boolean, default: false, null: false
add_column :group_users, :blocked, :boolean, default: false, null: false

  end
end	

