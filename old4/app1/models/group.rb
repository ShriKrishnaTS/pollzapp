class Group < ApplicationRecord
  validates_presence_of :name, :description, :privacy
  validates_presence_of :image, :allow_blank => true, :allow_nil => true

  enum privacy: ['Public', 'Closed', 'Private']

  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :polls
  has_many :votes, through: :polls

  mount_uploader :image, ImageUploader
  mount_base64_uploader :image, ImageUploader
end
