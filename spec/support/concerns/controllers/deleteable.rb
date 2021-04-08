shared_examples_for 'Controller Deleteable' do |resource|
  let(:scope) { resource.to_s.classify.constantize } unless instance_methods.include?(:scope)
  let(:format) { :html } unless instance_methods.include?(:format)
  let(:controller_action) { :destroy }
  let(:controller_method) { :delete }
  let(:resource_id) { send(resource).id }

  it "deletes #{resource} from the database" do
    expect { delete :destroy, params: { id: resource_id }, format: format }
      .to change(scope, :count).by(-1)
  end

  it_behaves_like 'Controller Renderable' do
    let(:params) { { id: resource_id } }
    let(:expected_response) { success_response }
  end
end
