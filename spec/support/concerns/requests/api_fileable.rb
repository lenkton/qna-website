shared_examples_for 'API Fileable' do
  it_behaves_like 'API Nestable', 'file' do
    let(:public_fields) { %w[id name created_at] }
    let(:private_fields) { %w[] }
  end

  it 'contails url field' do
    send api_method, api_path, params: { access_token: access_token.token }, headers: headers
    expect(received_fileable['files'].first['url']).to eq Rails.application.routes.url_helpers.polymorphic_url(fileable.files.first, only_path: true)
  end
end
