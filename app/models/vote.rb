class Vote < ApplicationRecord
  belongs_to :poll
  belongs_to :user

  validates_presence_of :user, :poll
  validates_uniqueness_of :poll, scope: :user
end
