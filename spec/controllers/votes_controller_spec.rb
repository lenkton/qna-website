require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:votable_type) { :answer }
  let(:author) { create :author }
  let(:votable) { create votable_type }
  let(:votable_plural_sym) { votable_type.to_s.pluralize.to_sym }

  describe 'POST #create' do
    context 'Authenticated user' do
      let(:id_field_name_sym) { (votable_type.to_s + '_id').to_sym }

      before { log_in author }

      context 'valid params' do
        it 'creates a vote in the database' do
          expect { post :create, params: { vote: { supportive: true }, id_field_name_sym => votable, votable: votable_plural_sym }, format: :json }.to change(votable.votes, :count).by(1)
        end

        it 'renders the created vote object as a JSON' do
          post :create, params: { vote: { supportive: true }, id_field_name_sym => votable, votable: votable_plural_sym }, format: :json
          expect(response.body).to eq({ votable_type => { vote: { status: :created, supportive: true, id: Vote.last.id } } }.to_json)
        end
      end

      context 'two same actions in a row' do
        let!(:existing_vote) { create :vote, author: author, votable: votable, supportive: true }

        it 'does not create a vote' do
          expect { post :create, params: { vote: { supportive: true }, id_field_name_sym => votable, votable: votable_plural_sym }, format: :json }.not_to change(votable.votes, :count)
        end

        it 'responces with an error' do
          post :create, params: { vote: { supportive: true }, id_field_name_sym => votable, votable: votable_plural_sym }, format: :json
          expect(response).to be_unprocessable
        end
      end

      context 'Votes for himself/herself' do
        let(:own_votable) { create votable_type, author: author }

        it 'does not create a vote' do
          expect { post :create, params: { vote: { supportive: true }, id_field_name_sym => own_votable, votable: votable_plural_sym }, format: :json }.not_to change(own_votable.votes, :count)
        end

        it 'responces with an error' do
          post :create, params: { vote: { supportive: true }, id_field_name_sym => own_votable, votable: votable_plural_sym }, format: :json
          expect(response).to be_forbidden
        end
      end

      context 'invalid params' do
        it 'does not create a vote' do
          expect { post :create, params: { vote: { supportive: nil }, id_field_name_sym => votable }, format: :json }.not_to change(Vote, :count)
        end

        it 'responces with an error' do
          post :create, params: { vote: { supportive: nil }, id_field_name_sym => votable }, format: :json
          expect(response).to be_unprocessable
        end
      end
    end
  end

  describe 'DELETE #destory' do
    let!(:vote) { create :vote, author: author, votable: votable }

    context 'The author' do
      before { log_in author }

      it 'destroys the vote' do
        expect { delete :destroy, params: { id: vote, votable: votable_plural_sym }, format: :json }.to change(votable.votes, :count).by(-1)
      end

      it 'renders a special json response' do
        delete :destroy, params: { id: vote, votable: votable_plural_sym }, format: :json
        expect(response.body).to eq({ votable_type => { vote: { status: :deleted, previous_value: vote.supportive } } }.to_json)
      end
    end

    context 'Random user' do
      before { log_in create(:user) }

      it 'does not destroy the vote' do
        expect { delete :destroy, params: { id: vote, votable: votable_plural_sym }, format: :json }.not_to change(vote.votable.votes, :count)
      end


      it 'does not destroy the vote' do
        expect { delete :destroy, params: { id: vote, votable: votable_plural_sym }, format: :json }.not_to change(vote.votable.votes, :count)
      end

      it 'returns an unauthorized error response' do
        delete :destroy, params: { id: vote, votable: votable_plural_sym }, format: :json
        expect(response).to be_unauthorized
      end
    end
  end
end
