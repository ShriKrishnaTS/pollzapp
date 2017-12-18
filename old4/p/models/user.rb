class User < ApplicationRecord
  validates_presence_of :phone
  validates_uniqueness_of :phone
  validates_uniqueness_of :username, :allow_blank => true, :allow_nil => true, :case_sensitive => false, message: 'has already been taken'
  enum language: ['English', 'Arabic']
  has_secure_token :auth_token
  has_one_time_password

  mount_uploader :image, ImageUploader
  mount_base64_uploader :image, ImageUploader

  has_many :user_groups, class_name: 'GroupUser', dependent: :destroy
  has_many :groups, through: :user_groups
  has_many :user_contacts
  has_many :contacts, through: :user_contacts
  has_many :polls
  has_many :votes
  has_many :voted_polls, through: :votes, source: :poll
  has_many :notifications
  has_many :devices
  has_many :poll_read_statuses
end