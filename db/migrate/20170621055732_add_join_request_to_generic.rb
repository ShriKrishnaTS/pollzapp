class AddJoinRequestToGeneric < ActiveRecord::Migration[5.0]
  def change
  	 add_column :users, :join_request_sent, :boolean, default: false
  end
end
