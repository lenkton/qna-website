shared_examples_for 'API Not Foundable' do
  it 'returns 404 error' do
    send api_method, invalid_path, params: { access_token: access_token.token }, headers: headers
    expect(response.status).to eq 404
  end
end
