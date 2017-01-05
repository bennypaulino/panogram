class Micropost < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :admirers, through: :likes, source: :user, dependent: :destroy
  has_many :comments

  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  # Use the singular to call a custom-rolled validation
  validate :picture_size

  # Trigger the cropping of an image with a callback
  after_update :crop_picture

  # CarrierWave will associate the image with a model by using the
  # mount_uploader method, which takes as arguments a symbol representing
  # the attribute and the class name of the generated uploader.
  mount_uploader :picture, PictureUploader
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  def crop_picture
    picture.recreate_versions! if crop_x.present?
  end

  private

  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
