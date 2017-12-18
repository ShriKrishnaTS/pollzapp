class CreateUserContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :user_contacts do |t|
      t.belongs_to :user, foreign: true
      t.integer :contact_id, unsigned: true, index: true
      t.boolean :blocked, default: false
      t.timestamps
    end
  end
end
