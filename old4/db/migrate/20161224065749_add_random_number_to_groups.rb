class AddRandomNumberToGroups < ActiveRecord::Migration[5.0]
  def change
     add_column :groups, :share_id, :string 
  end
end
