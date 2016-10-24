class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  # CarrierWave will associate the image with a model by using the mount_uploader method, which takes as arguments a symbol representing the attribute and the class name of the generated uploader
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
