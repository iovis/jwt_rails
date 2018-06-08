describe JwtToken, type: :model do
  subject { create :jwt_token }

  it 'auto generates a token on build' do
    jwt_token = described_class.create(user: create(:user))
    expect(jwt_token.token).not_to be_nil
  end
end
