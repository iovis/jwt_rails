class AuthorizationHeadersService
  AUTHORIZATION_HEADERS_REGEXP = /\Abearer\s+(?<token>\S+)\z/i

  def self.extract_token_from(request)
    request.headers.fetch('Authorization', '')[AUTHORIZATION_HEADERS_REGEXP, :token]
  end
end
