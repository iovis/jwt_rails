describe JwtService do
  let(:user)  { create :user }
  let(:token) { described_class.encode(sub: user.id, exp: 10.seconds.from_now) }
  subject     { described_class.decode(token) }

  it 'needs the subject property' do
    expect { described_class.encode }.to raise_error ArgumentError
  end

  it 'sets the expiration time' do
    expect(subject['exp']).to eq 10.seconds.from_now.to_i
  end

  context 'with a custom fields' do
    let(:token) { described_class.encode(sub: user.id, exp: 1.minute.from_now, email: user.email) }

    it 'sets the custom fields' do
      expect(subject['email']).to eq user.email
    end
  end
end
