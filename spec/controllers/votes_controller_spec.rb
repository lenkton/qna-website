require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  describe 'POST #create' do
    context 'Authenticated user' do
      let(:user) { create :user }
      let!(:question) { create :question }

      before { log_in user }

      context 'valid params' do
        it 'creates a vote in the database' do
          expect { post :create, params: { vote: { supportive: true }, question_id: question }, format: :json }.to change(question.votes, :count).by(1)
        end

        it 'renders the created vote object as a JSON' do
          post :create, params: { vote: { supportive: true }, question_id: question }, format: :json
          expect(response.body).to eq Vote.last.to_json
        end
      end

      context 'two same actions in a row' do
        let!(:existing_vote) { create :vote, user: user, question: question, supportive: true }

        it 'does not create a vote' do
          expect { post :create, params: { vote: { supportive: true }, question_id: question }, format: :json }.not_to change(question.votes, :count)
        end

        it 'responces with an error' do
          post :create, params: { vote: { supportive: true }, question_id: question }, format: :json
          expect(response).to be_unprocessable
        end
      end

      context 'invalid params' do
        it 'does not create a vote' do
          expect { post :create, params: { vote: { supportive: nil }, question_id: question }, format: :json }.not_to change(Vote, :count)
        end

        it 'responces with an error' do
          post :create, params: { vote: { supportive: nil }, question_id: question }, format: :json
          expect(response).to be_unprocessable
        end
      end
    end
  end
end
