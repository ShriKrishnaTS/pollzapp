class AddColumnToPolls < ActiveRecord::Migration[5.0]
  def change
add_column :polls, :end_msg_sent, :boolean, default: false, null: false
  end
end
