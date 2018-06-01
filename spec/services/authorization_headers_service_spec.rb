describe AuthorizationHeadersService do
  shared_examples 'a header parse' do |authorization_header, result|
    let(:request) { build_header(authorization_header) }
    subject { described_class.extract_token_from(request) }

    it 'parses the token' do
      is_expected.to eq result
    end
  end

  describe '.extract_token_from' do
    it_behaves_like 'a header parse'
    it_behaves_like 'a header parse', 'complete nonsense'
    it_behaves_like 'a header parse', 'complete bearer nonsense'
    it_behaves_like 'a header parse', 'bearer token', 'token'
    it_behaves_like 'a header parse', 'Bearer token', 'token'

    it_behaves_like 'a header parse',
      'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjEsImV4cCI6MTUyNzg2NjEzM30.SiG5mIWA3b975X-QGfr72d4ArGTuFbWw3QSz1U4PkqQ',
      'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjEsImV4cCI6MTUyNzg2NjEzM30.SiG5mIWA3b975X-QGfr72d4ArGTuFbWw3QSz1U4PkqQ'
  end

  def build_header(value)
    request = OpenStruct.new(headers: {})
    request.headers['Authorization'] = value if value
    request
  end
end
