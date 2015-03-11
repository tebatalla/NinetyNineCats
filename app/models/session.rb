class Session < ActiveRecord::Base
  validates :user_id, :token, presence: true

  after_initialize :set_token

  belongs_to :user

  def reset_session_token!
    self.token = SecureRandom::urlsafe_base64
    self.save
  end

  def set_token
    self.token ||= SecureRandom::urlsafe_base64
  end

end
