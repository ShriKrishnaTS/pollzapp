class ChangeColumnLastViewInPollReadStatus < ActiveRecord::Migration[5.0]
  def change
change_column :poll_read_statuses, :last_viewed, :datetime,  nil: true

  end
end
