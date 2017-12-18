class ChangeDefaultValueOfReadStatus < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:poll_read_statuses, :read, false)
  end
end
