require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:commentable_type) { :answer }
  let!(:commentable) { create(commentable_type) }
  let(:commentable_id_sym) { (commentable_type.to_s + '_id').to_sym }
  let(:user) { create :user }

  describe 'POST #create' do
    describe 'Authenticated user' do
      before { log_in user }

      context 'valid parameters' do
        it 'creates a comment for the commentable in the database' do
          expect { post :create, params: { comment: attributes_for(:comment), commentable_id_sym => commentable.id, commentable: commentable_type }, format: :json }
            .to change(commentable.comments, :count).by(1)
        end

        it 'renders a special JSON' do
          post :create, params: { comment: attributes_for(:comment), commentable_id_sym => commentable.id, commentable: commentable_type }, format: :json

          expect(response.body).to eq({ comment: Comment.last }.to_json)
        end

        it "broadcasts the comment to the comments channel" do
          expect { post :create, params: { comment: attributes_for(:comment), commentable_id_sym => commentable.id, commentable: commentable_type }, format: :json }
            .to(
              have_broadcasted_to(CommentsChannel.broadcasting_for(commentable))
                .with { |data| expect(data.to_json).to eq({ comment: Comment.last }.to_json) }
            )
        end
      end

      context 'invalid parameters' do
        it 'does not create a comment in the database' do
          expect { post :create, params: { comment: attributes_for(:comment, :invalid), commentable_id_sym => commentable.id, commentable: commentable_type }, format: :json }
            .not_to change(Comment, :count)
        end

        it 'responds with an error' do
          post :create, params: { comment: attributes_for(:comment, :invalid), commentable_id_sym => commentable.id, commentable: commentable_type }, format: :json

          expect(response).to be_unprocessable
        end

        it "broadcasts no comment to the comments channel" do
          expect { post :create, params: { comment: attributes_for(:comment, :invalid), commentable_id_sym => commentable.id, commentable: commentable_type }, format: :json }
            .not_to have_broadcasted_to(CommentsChannel.broadcasting_for(commentable))
        end
      end
    end
  end
end
