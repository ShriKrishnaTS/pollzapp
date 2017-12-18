class Poll < ApplicationRecord
  belongs_to :group
  belongs_to :user
  has_many :votes
  has_and_belongs_to_many :tags
  has_many :poll_read_statuses
  has_many :comments

  validates_presence_of :duration, :title, :question, :ends_on, :option_1, :option_2, :group
  validates_presence_of :image_1, :allow_blank => true, :allow_nil => true
  validates_presence_of :image_2, :allow_blank => true, :allow_nil => true
  validates_presence_of :video, :allow_blank => true, :allow_nil => true


  mount_uploader :image_1, ImageUploader
  mount_uploader :image_2, ImageUploader
  mount_uploader :composite, ImageUploader
  mount_base64_uploader :image_1, ImageUploader, file_name: "poll_pic_1_#{Time.now.to_i}"
  mount_base64_uploader :image_2, ImageUploader, file_name: "poll_pic_2_#{Time.now.to_i}"
  mount_uploader :video, VideoUploader

  self.per_page = 20
end
