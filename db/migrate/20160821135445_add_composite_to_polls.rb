class AddCompositeToPolls < ActiveRecord::Migration[5.0]
  def change
    add_column :polls, :composite, :string
  end
end
