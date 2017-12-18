class AddActiveToGroupUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :group_users, :active, :boolean, default: true
  end
end
