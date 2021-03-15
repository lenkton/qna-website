require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:author) { create(:author) }
  let(:random_user) { create(:user) }

  describe 'POST #create' do
    let!(:question) { create(:question) }

    before { log_in(author) }

    context 'valid parameters' do
      it 'creates an answer for the question in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'renders the create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js

        expect(response).to render_template(:create)
      end
    end

    context 'invalid parameters' do
      it 'does not create an answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders the create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js

        expect(response).to render_template(:create)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, author: author, question: question) }

    context 'Author' do
      before { log_in(author) }

      it 'deletes his/her answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(question.answers, :count).by(-1)
      end

      it 'renders the destroy template' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to render_template(:destroy)
      end
    end

    context 'Random user' do
      before { log_in(random_user) }

      it 'does not delete the answer in the database' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders the destroy template' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to render_template(:destroy)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, author: author, body: 'old body') }

    context 'Author' do
      before { log_in(author) }

      context 'with valid parameters' do
        before { patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js }

        it 'updates the answer' do
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'renders the update template' do
          expect(response).to render_template(:update)
        end
      end

      context 'with invalid parameters' do
        before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }

        it 'does not change the answer' do
          answer.reload

          expect(answer.body).to eq 'old body'
        end

        it 'renders the update template' do
          expect(response).to render_template(:update)
        end
      end
    end

    context 'Random user' do
      before do
        log_in(random_user)
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
      end

      it 'does not change the answer' do
        answer.reload

        expect(answer.body).to eq 'old body'
      end

      it 'renders the update template' do
        expect(response).to render_template(:update)
      end
    end
  end
end
