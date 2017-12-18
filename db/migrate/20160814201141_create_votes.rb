class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.belongs_to :poll
      t.belongs_to :user
      t.string :choice

      t.timestamps
    end
    add_foreign_key :votes, :polls, on_delete: :cascade
    add_foreign_key :votes, :users, on_delete: :cascade
  end
end
