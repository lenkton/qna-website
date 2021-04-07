shared_examples_for 'Controller Broadcastable' do |resource|
  let(:scope) { resource.to_s.classify.constantize }
  let(:additional_params) { {} } unless instance_methods.include?(:additional_params)
  let(:format) { :html } unless instance_methods.include?(:format)

  context 'valid' do
    it "broadcasts the #{resource} to the channel" do
      expect { post :create, params: { resource => attributes_for(resource) }.merge(additional_params), format: format }
        .to(have_broadcasted_to(channel_name).with { |data| expect(data).to eq expected_response })
    end
  end

  context 'invalid' do
    it "broadcasts no #{resource} to the channel" do
      expect { post :create, params: { resource => attributes_for(resource, :invalid) }.merge(additional_params), format: format }
        .not_to have_broadcasted_to(channel_name)
    end
  end
end
