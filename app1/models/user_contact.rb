class UserContact < ApplicationRecord
  belongs_to :user
  belongs_to :contact, class_name: 'User'
  validates_uniqueness_of :contact_id, scope: :user_id, message: 'Contact already exists', :allow_blank => true, :allow_nil => true

  scope :blocked, -> { where blocked: true }
end
