shared_examples_for 'API Authorizable' do
  let(:additional_params) { {} } unless instance_methods.include?(:additional_params)

  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      send api_method, api_path, params: additional_params, headers: headers
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      send api_method, api_path, params: additional_params.merge({ access_token: '1234' }), headers: headers
      expect(response.status).to eq 401
    end
  end

  context 'authorized' do
    it 'returns 200 status' do
      send api_method, api_path, params: { access_token: access_token.token }.merge(additional_params), headers: headers
      expect(response).to be_successful
    end
  end
end
