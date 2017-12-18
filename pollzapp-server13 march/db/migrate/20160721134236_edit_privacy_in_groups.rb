class EditPrivacyInGroups < ActiveRecord::Migration[5.0]
  def change
change_column :groups, :privacy, :tinyint, :limit => 1
  end
end
