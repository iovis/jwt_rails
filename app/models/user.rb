class User < ApplicationRecord
  INACTIVITY_WINDOW = 20.minutes

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :token, class_name: 'JwtToken'

  def active?
    current_sign_in_at > INACTIVITY_WINDOW.ago
  end
end
