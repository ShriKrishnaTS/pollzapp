class CreatePollReadStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :poll_read_statuses do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :poll, foreign_key: true
      t.boolean :read

      t.timestamps
    end
  end
end
