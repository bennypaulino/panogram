class Like < ApplicationRecord
  belongs_to :micropost
  belongs_to :user
  validates :user_id, presence: true
  # can also be the following
  # validates :user, presence: true
  validates :micropost_id, presence: true

end
