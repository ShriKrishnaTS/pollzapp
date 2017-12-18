class AddDeletedDisabledMediaToPolls < ActiveRecord::Migration[5.0]
  def change
    add_column :polls, :deleted, :boolean, default: false
    add_column :polls, :media_disabled, :boolean, default: false
  end
end
