class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.string :text
      t.text :parts
      t.string :icon
      t.belongs_to :user, foreign_key: true
      t.boolean :pushed, default: false, null: false
      t.timestamps
    end
  end
end
