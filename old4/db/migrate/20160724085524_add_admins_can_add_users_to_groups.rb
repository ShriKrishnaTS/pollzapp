class AddAdminsCanAddUsersToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :admins_can_add_users, :boolean, default: true
    add_column :groups, :members_can_create_polls, :boolean, default: true
  end
end
