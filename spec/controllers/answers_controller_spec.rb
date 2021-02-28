require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let!(:question) { create(:question) }
    let(:author) { create(:author) }

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
    let(:author) { create(:author) }
    let(:random_user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, author: author, question: question) }

    context 'Author' do
      before { log_in(author) }

      it 'deletes his/her answer' do
        expect { delete :destroy, params: { id: answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirects to the question page' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to question
      end
    end

    context 'Random user' do
      before { log_in(random_user) }

      it 'does not delete the answer in the database' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'renders the question show view' do
        delete :destroy, params: { id: answer }

        expect(response).to render_template('questions/show')
      end
    end

    context 'Unauthenticated user' do
      it 'does not delete the answer in the database' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'renders the question show view' do
        delete :destroy, params: { id: answer }

        expect(response).to render_template('questions/show')
      end
    end
  end
end
