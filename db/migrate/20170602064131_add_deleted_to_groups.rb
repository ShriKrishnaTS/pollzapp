class AddDeletedToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :deleted, :boolean, default: false
  end
end
