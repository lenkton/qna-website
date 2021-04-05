shared_examples_for 'API Linkable' do
  it_behaves_like 'API Nestable', 'link' do
    let(:links_list_size) { 5 }
    let!(:links) { create_list :link, links_list_size, linkable: linkable }
    let(:public_fields) { %w[id url name created_at updated_at] }
    let(:private_fields) { %w[] }
  end
end
