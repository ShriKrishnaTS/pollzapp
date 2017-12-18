class AddContactDetailsFields < ActiveRecord::Migration[5.0]
  def change
    add_column :user_contacts, :name, :string
    add_column :user_contacts, :phone, :string
  end
end
