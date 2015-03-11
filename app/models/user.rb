class User < ActiveRecord::Base
  attr_reader :password

  after_initialize :set_token

  validates :user_name, :session_token, :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }

  has_many :cats
  has_many :cat_rental_requests

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(@password)
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest) == password
  end

  private

  def set_token
    self.session_token ||= SecureRandom::urlsafe_base64
  end


end
