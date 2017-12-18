class Device < ApplicationRecord
  belongs_to :user
  validates_presence_of :push_token, :os, :user
end
