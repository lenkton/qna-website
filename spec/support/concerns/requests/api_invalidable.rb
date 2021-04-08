shared_examples_for 'API Invalidable' do
  it 'returns `unprocessable` status for invalid params' do
    send api_method, api_path, params: { access_token: access_token.token }.merge(invalid_params), headers: headers
    expect(response).to be_unprocessable
  end

  it 'returns list of error messages' do
    send api_method, api_path, params: { access_token: access_token.token }.merge(invalid_params), headers: headers
    expect(response.body).to include('не может быть пустым')
  end
end
