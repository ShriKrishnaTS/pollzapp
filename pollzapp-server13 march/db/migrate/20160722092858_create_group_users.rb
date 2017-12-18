class CreateGroupUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :group_users do |t|
      t.integer :group_id
      t.integer :user_id
      t.boolean :comments_enabled
      t.boolean :new_polls_enabled

      t.timestamps
    end
  end
end
