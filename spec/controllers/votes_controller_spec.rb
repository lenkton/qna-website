require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  describe 'POST #create' do
    context 'Authenticated user' do
      let(:author) { create :author }
      let!(:question) { create :question }

      before { log_in author }

      context 'valid params' do
        it 'creates a vote in the database' do
          expect { post :create, params: { vote: { supportive: true }, question_id: question }, format: :json }.to change(question.votes, :count).by(1)
        end

        it 'renders the created vote object as a JSON' do
          post :create, params: { vote: { supportive: true }, question_id: question }, format: :json
          expect(response.body).to eq({ question: { vote: { status: :created, supportive: true, id: Vote.last.id } } }.to_json)
        end
      end

      context 'two same actions in a row' do
        let!(:existing_vote) { create :vote, author: author, question: question, supportive: true }

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

  describe 'DELETE #destory' do
    let(:author) { create :author }
    let!(:vote) { create :vote, author: author }

    context 'The author' do
      before { log_in author }

      it 'destroys the vote' do
        expect { delete :destroy, params: { id: vote }, format: :json }.to change(vote.question.votes, :count).by(-1)
      end

      it 'renders a special json response' do
        delete :destroy, params: { id: vote }, format: :json
        expect(response.body).to eq({ question: { vote: { status: :deleted, previous_value: vote.supportive } } }.to_json)
      end
    end

    context 'Random user' do
      before { log_in create(:user) }

      it 'does not destroy the vote' do
        expect { delete :destroy, params: { id: vote }, format: :json }.not_to change(vote.question.votes, :count)
      end

      it 'returns an unauthorized error response' do
        delete :destroy, params: { id: vote }, format: :json
        expect(response).to be_unauthorized
      end
    end
  end
end
