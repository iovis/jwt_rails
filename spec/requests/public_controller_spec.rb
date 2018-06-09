describe PublicController, type: :request do
  describe '/public/index' do
    let(:index) { '/public/index' }

    before :each do
      get index
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end
end
