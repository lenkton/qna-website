require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:question) { create(:question) }
  let(:user) { create :user }

  describe 'POST #create' do
    describe 'Authenticated user' do
      before { log_in user }

      context 'valid parameters' do
        it 'creates a comment for the question in the database' do
          expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }.to change(question.comments, :count).by(1)
        end

        it 'renders the create template' do
          post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js

          expect(response).to render_template(:create)
        end

        it "broadcasts the comment to the question's channel" do
          expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }
            .to(
              have_broadcasted_to("question_#{question.id}_channel")
                .with { |data| expect(data.to_json).to eq({ comment: Comment.last }.to_json) }
            )
        end
      end

      context 'invalid parameters' do
        it 'does not create a comment in the database' do
          expect { post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question }, format: :js }.to_not change(Comment, :count)
        end

        it 'renders the create template' do
          post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question }, format: :js

          expect(response).to render_template(:create)
        end

        it "broadcasts no comment to the question's channel" do
          expect { post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question }, format: :js }
            .not_to have_broadcasted_to("question_#{question.id}_channel")
        end
      end
    end
  end
end
