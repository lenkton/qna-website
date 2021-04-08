shared_examples_for 'Controller Updateable' do |resource|
  let(:old_attributes) { attributes_for resource, :old }
  let(:new_attributes) { attributes_for resource }
  let!(:old) { create resource, old_attributes.merge({ author: author }) }
  let(:format) { :html } unless instance_methods.include?(:format)
  let(:controller_action) { :update }
  let(:controller_method) { :patch }

  context 'valid parameters' do
    it "updates #{resource} attributes in the database" do
      patch :update, params: { resource => new_attributes, id: old.id }, format: format
      expect(old.reload).to have_attributes(new_attributes)
    end

    it_behaves_like 'Controller Renderable' do
      let(:params) { { resource => new_attributes, id: old.id } }
      let(:expected_response) { success_response }
    end
  end

  context 'invalid parameters' do
    let(:invalid_attributes) { attributes_for resource, :invalid }

    it "does not update #{resource} attributes in the database" do
      patch :update, params: { resource => invalid_attributes, id: old.id }, format: format
      expect(old.reload).to have_attributes(old_attributes)
    end

    it_behaves_like 'Controller Renderable' do
      let(:params) { { resource => invalid_attributes, id: old.id } }
      let(:expected_response) { failure_response }
    end
  end
end
