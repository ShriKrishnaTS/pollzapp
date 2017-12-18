class ChangeDefaultTypesInGroupUsers < ActiveRecord::Migration[5.0]
  def change
    change_column :group_users, :comments_enabled, :boolean, :limit => 1, :default => false
    change_column :group_users, :new_polls_enabled, :boolean, :limit => 1, :default => false
  end
end
