class User < ApplicationRecord
  attr_accessor :remember_token

  before_save { self.email = email.downcase; self.username = username.downcase }

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
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forget a user, if they decide to log out.
  def forget
    update_attribute(:remember_digest, nil)
  end
end
