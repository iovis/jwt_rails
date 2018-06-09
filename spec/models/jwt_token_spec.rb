describe JwtToken, type: :model do
  subject    { create :jwt_token }
  let(:user) { build_stubbed :user }

  describe 'callbacks' do
    describe 'before_save' do
      it 'generates a token ' do
        jwt_token = described_class.create(user: user)
        expect(jwt_token.token).not_to be_nil
      end
    end
  end

  describe '.generate_for' do
    context 'when the user has no token' do
      it 'creates one' do
        token = described_class.generate_for(user)
        expect(user.token).to eq token
      end
    end

    context 'when the user has a token' do
      it 'refreshes the token' do
        allow(JwtService).to receive(:encode).and_return('first_token', 'second_token')

        user = subject.user
        old_token = subject.token
        new_token_model = described_class.generate_for(user)

        expect(old_token).to eq 'first_token'
        expect(new_token_model.token).to eq 'second_token'
        expect(user.token).to eq new_token_model
      end
    end
  end

  describe '#to_s' do
    it 'returns the token' do
      expect(subject.to_s).to eq subject.token
    end
  end

  describe '#to_header' do
    it 'returns the token header' do
      expect(subject.to_headers).to eq('Authorization' => "Bearer #{subject.token}")
    end
  end

  describe '#payload' do
    it 'returns the decoded token' do
      payload = subject.payload
      expect(payload['sub']).to eq subject.user_id
    end
  end

  describe '#active?' do
    context 'when the token has not expired' do
      it 'returns true' do
        is_expected.to be_active
      end
    end

    context 'when the token has expired' do
      subject { build_stubbed :jwt_token, :expired }

      it 'returns false' do
        is_expected.not_to be_active
      end
    end
  end
end
