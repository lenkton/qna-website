shared_examples_for 'API Commentable' do
  it_behaves_like 'API Nestable', 'comment' do
    let(:comments_list_size) { 5 }
    let!(:comments) { create_list :comment, comments_list_size, commentable: commentable }
    let(:public_fields) { %w[id text author_id created_at updated_at] }
    let(:private_fields) { %w[] }
  end
end
