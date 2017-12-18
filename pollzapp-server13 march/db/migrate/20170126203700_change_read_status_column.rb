class ChangeReadStatusColumn < ActiveRecord::Migration[5.0]
  def change
         change_column :poll_read_statuses, :read, :boolean, :default => false	 

  end
end
