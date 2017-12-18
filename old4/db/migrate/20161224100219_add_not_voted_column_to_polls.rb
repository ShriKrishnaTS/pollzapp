class AddNotVotedColumnToPolls < ActiveRecord::Migration[5.0]
  def change
  	add_column :polls, :not_voted, :boolean, default: false, null: false
  end
end
