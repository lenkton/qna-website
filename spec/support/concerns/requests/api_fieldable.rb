shared_examples_for 'API Fieldable' do
  let(:additional_params) { {} } unless instance_methods.include?(:additional_params)
  let(:private_fields) { [] } unless instance_methods.include?(:private_fields)

  before { send api_method, api_path, params: { access_token: access_token.token }.merge(additional_params), headers: headers }

  it 'returns all public fields' do
    # byebug
    public_fields.each do |attr|
      expect(received_fieldable[attr]).to eq fieldable.send(attr).as_json
    end
  end

  it 'does not return private fields' do
    private_fields.each do |attr|
      expect(received_fieldable).not_to have_key(attr)
    end
  end
end
