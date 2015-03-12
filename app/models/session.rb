class Session < ActiveRecord::Base
  validates :user_id, :token, presence: true

  after_initialize :set_token

  belongs_to :user

  def set_token
    self.token ||= SecureRandom::urlsafe_base64
  end

end
