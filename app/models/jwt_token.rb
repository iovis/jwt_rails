class JwtToken < ApplicationRecord
  EXPIRATION_TIME = 10.minutes

  belongs_to :user

  validates :user, uniqueness: true

  before_save :generate

  def self.generate_for(user)
    token = find_or_initialize_by(user: user)
    token.save && token
  end

  def active?
    JwtService.decode(token).present?
  rescue ::JWT::ExpiredSignature
    false
  end

  private

  def generate
    self.token = JwtService.encode(sub: user_id, exp: EXPIRATION_TIME.from_now)
  end
end
