shared_examples_for 'Controller Renderable' do
  let(:format) { :html } unless instance_methods.include?(:format)

  it 'responds with a suitable response' do
    send controller_method, controller_action, params: params, format: format

    expect(response).to expected_response
  end
end
