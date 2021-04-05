shared_examples_for 'API Listable' do
  it 'return a list of the objects' do
    send api_method, api_path, params: { access_token: access_token.token }, headers: headers
    expect(send("received_#{list_name}").size).to eq(send(list_name).size)
  end
end
