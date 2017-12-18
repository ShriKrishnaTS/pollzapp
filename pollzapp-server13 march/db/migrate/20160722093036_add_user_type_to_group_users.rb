class AddUserTypeToGroupUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :group_users, :user_type, :tinyint, :limit => 1
  end
end
