class CreatePolls < ActiveRecord::Migration[5.0]
  def change
    create_table :polls do |t|
      t.string :title
      t.string :question
      t.integer :duration, unsigned: true
      t.datetime :ends_on
      t.boolean :comments_enabled, default: true
      t.references :group
      t.references :user
      t.string :image_1
      t.string :image_2
      t.string :option_1
      t.string :option_2
      t.timestamps
    end
    add_foreign_key :polls, :groups, on_delete: :cascade
    add_foreign_key :polls, :users, on_delete: :cascade
  end
end
