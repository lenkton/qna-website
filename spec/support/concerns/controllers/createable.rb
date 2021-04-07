shared_examples_for 'Controller Createable' do |resource|
  let(:attributes) { attributes_for resource }
  let(:scope) { resource.to_s.classify.constantize }
  let(:additional_params) { {} } unless instance_methods.include?(:additional_params)
  let(:format) { :html } unless instance_methods.include?(:format)

  context 'valid parameters' do
    it "creates #{resource} in the database" do
      expect { post :create, params: { resource => attributes }.merge(additional_params), format: format }
        .to change(scope, :count).by(1)
    end
  end

  context 'invalid parameters' do
    let(:invalid_attributes) { attributes_for resource, :invalid }

    it "does not create #{resource} in the database" do
      expect { post :create, params: { resource => invalid_attributes }.merge(additional_params), format: format }
        .to_not change(scope, :count)
    end
  end
end
