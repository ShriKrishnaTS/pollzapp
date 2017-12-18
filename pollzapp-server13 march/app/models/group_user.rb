class GroupUser < ApplicationRecord
  validates_presence_of :user_type, :user
  validates_uniqueness_of :user_id, scope: :group_id, message: 'User already exists in group'
  enum user_type: ['Member', 'Group Admin', 'Group Owner']
  belongs_to :group
  belongs_to :user

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :blocked, -> { where(blocked: true) }
  scope :unblocked, -> { where(blocked: false) }

  scope :owners, -> { where(user_type: 'Group Owner') }
end
