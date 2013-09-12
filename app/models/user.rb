require 'SecureRandom'

class User < ActiveRecord::Base
  attr_accessible :user_name, :session_token, :password
  attr_reader :password

  before_validation do
    self.session_token ||= User.generate_session_token
  end

  validates :password_digest, :user_name, :session_token, presence: true
  validates :user_name, :session_token, uniqueness: true
  validates :password_digest, presence: { message: "Password can't be blank" }
  validates :password, length: { minimum: 6, allow_nil: true }

  has_many(
  :cats,
  class_name: "Cat",
  foreign_key: :user_id,
  primary_key: :id)

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def reset_session_token!
    session_token = User.generate_session_token
    self.save!
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by_user_name(user_name)
    user.is_password?(password) ? user : nil
  end
end
