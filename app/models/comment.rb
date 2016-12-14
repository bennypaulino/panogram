class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable

  default_scope -> { order(created_at: :asc) }

  validates :body, presence: true, length: { maximum: 220 }
end
