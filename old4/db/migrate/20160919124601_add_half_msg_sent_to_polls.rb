class AddHalfMsgSentToPolls < ActiveRecord::Migration[5.0]
  def change
add_column :polls, :half_time_msg_sent, :boolean, default: false, null: false
add_column :polls, :before_an_hour_msg_sent, :boolean, default: false, null: false

  end
end
