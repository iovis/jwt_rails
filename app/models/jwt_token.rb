class JwtToken < ApplicationRecord
  EXPIRATION_TIME = 10.minutes

  belongs_to :user

  validates :user, uniqueness: true

  before_save :generate

  def self.generate_for(user)
    token = find_or_initialize_by(user: user)
    token.save && token
  end

  def self.find_from(request)
    token = AuthorizationHeadersService.extract_token_from(request)
    find_by(token: token) if token
  end

  def to_s
    token
  end

  def to_headers
    { 'Authorization' => "Bearer #{token}" }
  end

  def payload
    JwtService.decode(token)
  end

  def active?
    payload.present?
  rescue ::JWT::ExpiredSignature
    false
  end

  private

  def generate
    self.token = JwtService.encode(sub: user_id, exp: EXPIRATION_TIME.from_now)
  end
end
