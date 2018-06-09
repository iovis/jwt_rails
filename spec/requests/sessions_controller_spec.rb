describe SessionsController, type: :request do
  let(:invalid_login_response) do
    {
      success: false,
      error: 'Invalid login or password'
    }.to_json
  end

  describe '/users/sign_in' do
    let(:sign_in) { '/users/sign_in' }
    let(:user)    { create :user }

    context 'with valid credentials' do
      it 'returns the token' do
        post sign_in, params: {
          user_login: {
            login: user.email,
            password: user.password
          }
        }

        expect(response).to have_http_status(:success)
        expect(response.body).to eq({
          success: true,
          auth_token: user.reload.token.to_s
        }.to_json)
      end
    end

    context 'with invalid credentials' do
      it 'returns an error' do
        post sign_in, params: {
          user_login: {
            login: user.email,
            password: 'fistro!'
          }
        }

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq invalid_login_response
      end
    end

    context 'with invalid parameters' do
      it 'returns an error when empty' do
        post sign_in

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq invalid_login_response
      end

      it 'returns an error with malformed data' do
        post sign_in, params: { login: user.email, password: user.password }

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq invalid_login_response
      end
    end
  end
end
