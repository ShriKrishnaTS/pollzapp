class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :description
      t.string :image
      t.string :privacy
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
