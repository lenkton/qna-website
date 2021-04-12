shared_examples_for 'Controller Createable' do |resource|
  let(:attributes) { attributes_for resource }
  let(:scope) { resource.to_s.classify.constantize }
  let(:additional_params) { {} } unless instance_methods.include?(:additional_params)
  let(:format) { :html } unless instance_methods.include?(:format)
  let(:controller_action) { :create }
  let(:controller_method) { :post }

  context 'valid parameters' do
    it "creates #{resource} in the database" do
      expect { post :create, params: { resource => attributes }.merge(additional_params), format: format }
        .to change(scope, :count).by(1)
    end

    it_behaves_like 'Controller Renderable' do
      let(:params) { { resource => attributes }.merge(additional_params) }
      let(:expected_response) { success_response }
    end
  end

  if instance_methods.include?(:failure_response)
    context 'invalid parameters' do
      let(:invalid_attributes) { attributes_for resource, :invalid }

      it "does not create #{resource} in the database" do
        expect { post :create, params: { resource => invalid_attributes }.merge(additional_params), format: format }
          .to_not change(scope, :count)
      end

      it_behaves_like 'Controller Renderable' do
        let(:params) { { resource => invalid_attributes }.merge(additional_params) }
        let(:expected_response) { failure_response }
      end
    end
  end
end
