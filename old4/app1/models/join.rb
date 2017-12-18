class Join < ApplicationRecord
	 

	validates_uniqueness_of :user_id, scope: :group_id, message: 'User already exists in group'
	enum status: ['accepted', 'requested', 'rejected']
	belongs_to :group
	belongs_to :user
end