class AddVideoToPolls < ActiveRecord::Migration[5.0]
  def change
    add_column :polls, :video, :string
  end
end
