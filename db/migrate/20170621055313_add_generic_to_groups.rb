class AddGenericToGroups < ActiveRecord::Migration[5.0]
  def change
      add_column :groups, :generic, :boolean, default: false
 end
end
