class User < ApplicationRecord
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :microposts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :micropost,
            dependent: :destroy
  # dependent: :destroy prevents userless microposts from being stranded in the
  # database when admins choose to remove users from the system

  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email, :downcase_username
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :username, presence: true, length: { maximum: 50 },
                       uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  has_secure_password

  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Random token used in persistent cookies, accnt activ., & psswrd reset links.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Links remember token w/user & saves matching remember digest to the database
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute( :remember_digest, User.digest(remember_token) )
  end

  # Returns true if the given token matches the digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forget a user, if they decide to log out.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    # update_attribute(:activated, true)
    # update_attribute(:activated_at, Time.zone.now)
    # Hit the database only once with a call to update_columns
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    #update_attribute(:reset_digest, User.digest(reset_token))
    #update_attribute(:reset_sent_at, Time.zone.now)
    update_columns(reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Password reset sent EARLIER than two hours ago?
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Return a user's status feed
  def feed
    #Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  # Follow another user
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Stop following a particular user
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  def liking?(micropost)
    liked_posts.include?(micropost)
  end

  def like_post(other_micropost)
    likes.create(micropost_id: other_micropost.id)
  end

  # Stop liking a particular micropost
  def dislike(other_micropost)
    likes.find_by(micropost_id: other_micropost.id).destroy
  end

  private

  # Converts email to all lower-case
  def downcase_email
    email.downcase! # or... self.email = email.downcase
  end

  def downcase_username
    self.username = username.downcase
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
