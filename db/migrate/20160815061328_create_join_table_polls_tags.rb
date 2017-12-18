class CreateJoinTablePollsTags < ActiveRecord::Migration[5.0]
  def change
    create_join_table :polls, :tags do |t|
      t.index [:poll_id, :tag_id]
      # t.index [:tag_id, :poll_id]
    end
  end
end
