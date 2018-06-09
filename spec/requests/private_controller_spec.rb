describe PrivateController, type: :request do
  describe '/private/index' do
    let(:index) { '/private/index' }

    context 'when not logged in' do
      before :each do
        get index
      end

      it 'returns http unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when logged in' do
      let(:user)  { create :user }
      let(:token) { JwtToken.generate_for(user) }

      before :each do
        get index, params: {}, headers: token.to_headers
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the user' do
        expect(response.body).to eq({ user: user.reload }.to_json)
      end
    end
  end
end
