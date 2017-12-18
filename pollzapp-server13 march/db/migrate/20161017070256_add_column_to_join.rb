class AddColumnToJoin < ActiveRecord::Migration[5.0]
  def change
  	add_column :joins, :status, :tinyint, :limit => 1
  end
end
