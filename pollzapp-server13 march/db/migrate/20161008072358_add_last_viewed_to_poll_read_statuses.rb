class AddLastViewedToPollReadStatuses < ActiveRecord::Migration[5.0]
  def change
    add_column :poll_read_statuses, :last_viewed, :datetime
  end
end
