describe JwtToken, type: :model do
  subject    { create :jwt_token }
  let(:user) { create(:user) }

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
end
