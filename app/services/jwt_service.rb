class JwtService
  EXPIRATION_TIME = 10.minutes

  def self.encode(sub:, exp: EXPIRATION_TIME.from_now, **keyword_args)
    payload = { sub: sub, exp: exp.to_i, **keyword_args }
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base).first
  end

  def self.unsafe_decode(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base, false).first
  end
end
