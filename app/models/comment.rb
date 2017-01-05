class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :micropost

  default_scope -> { order(created_at: :desc) }
  validates :body, presence: true, length: { maximum: 140 }

  acts_as_tree
end
