module Devise
  module Strategies
    class JWT < Base
      def valid?
        token.present?
      end

      def authenticate!
        payload = JwtService.decode(token)
        success! User.find(payload['sub'])
      rescue ::JWT::ExpiredSignature
        fail! 'Auth token has expired. Please log in again'
      rescue ::JWT::DecodeError
        fail! 'Auth token is invalid'
      end

      private

      AUTHORIZATION_HEADERS_REGEXP = /\Abearer\s+(?<token>\S+)\z/i

      def token
        @token ||= request.headers.fetch('Authorization', '')[AUTHORIZATION_HEADERS_REGEXP, :token]
      end
    end
  end
end

Warden::Strategies.add(:jwt, Devise::Strategies::JWT)
