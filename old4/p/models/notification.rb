class Notification < ApplicationRecord
  belongs_to :user

  validates_presence_of :user, :text, :parts
  mount_uploader :icon
  serialize :parts, Array
end
