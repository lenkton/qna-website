require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:commentable_type) { :answer }
  let!(:commentable) { create(commentable_type) }
  let(:commentable_id_sym) { (commentable_type.to_s + '_id').to_sym }
  let(:user) { create :user }

  describe 'POST #create' do
    describe 'Authenticated user' do
      let(:format) { :json }
      let(:additional_params) { { commentable_id_sym => commentable.id, commentable: commentable_type } }

      before { log_in user }

      it_behaves_like 'Controller Createable', :comment

      it_behaves_like 'Controller Broadcastable', :comment do
        let(:channel_name) { CommentsChannel.broadcasting_for(commentable) }
        let(:expected_response) { Comment.last.as_json(root: 'comment') }
      end

      context 'valid parameters' do
        it 'renders a special JSON' do
          post :create, params: { comment: attributes_for(:comment), commentable_id_sym => commentable.id, commentable: commentable_type }, format: :json

          expect(response.body).to eq({ comment: Comment.last }.to_json)
        end
      end

      context 'invalid parameters' do
        it 'responds with an error' do
          post :create, params: { comment: attributes_for(:comment, :invalid), commentable_id_sym => commentable.id, commentable: commentable_type }, format: :json

          expect(response).to be_unprocessable
        end
      end
    end
  end
end
