class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :poll

  validates_presence_of :user, :poll, :body
end
