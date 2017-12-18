class Vote < ApplicationRecord
  belongs_to :poll
  belongs_to :user
  # scope :unvoted, -> { JOIN (:polls).where('poll_id = ?', polls.id) }

  validates_presence_of :user, :poll
  validates_uniqueness_of :poll, scope: :user
end
