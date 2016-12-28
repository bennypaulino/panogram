class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_many :comments, as: :commentable

  default_scope -> { order(created_at: :desc) }

  validates :body, presence: true, length: { maximum: 140 }
end
