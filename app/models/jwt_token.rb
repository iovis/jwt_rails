class JwtToken < ApplicationRecord
  EXPIRATION_TIME = 10.minutes

  belongs_to :user

  validates :user, uniqueness: true

  before_create :generate

  def generate
    self.token = JwtService.encode(sub: user_id, exp: EXPIRATION_TIME.from_now)
  end
end
