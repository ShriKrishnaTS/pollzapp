class AddPasswordToUsers < ActiveRecord::Migration[5.0]
  def change
  	    add_column :users, :password, :string
  	    add_column :users, :email, :string
  	   	add_column :users, :is_web_admin, :boolean, default: false	
  end
end
