class RemoveUserFromGroups < ActiveRecord::Migration[5.0]
  def up
    remove_foreign_key :groups, :users
    remove_column :groups, :user_id
  end
  def down
    add_reference :groups, :user
    add_foreign_key :groups, :users
  end
end
