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

      it_behaves_like 'Controller Createable', :comment do
        let(:success_response) { satisfy { response.body == Comment.last.to_json(root: 'comment') } }
        let(:failure_response) { be_unprocessable }
      end

      it_behaves_like 'Controller Broadcastable', :comment do
        let(:channel_name) { CommentsChannel.broadcasting_for(commentable) }
        let(:expected_response) { Comment.last.as_json(root: 'comment') }
      end
    end
  end
end
