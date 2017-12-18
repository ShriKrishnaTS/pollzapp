class CreateDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :devices do |t|
      t.belongs_to :user, foreign_key: true
      t.string :os
      t.string :push_token

      t.timestamps
    end
  end
end
