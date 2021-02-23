require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create' do

    before { log_in(user) }

    context 'valid parameters' do
      it 'creates a question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to the question' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to(Question.find_by(attributes_for(:question)))
      end
    end

    context 'invalid parameters' do
      it 'does not create a question in the database' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 'renders the new veiw' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { user.questions.create(attributes_for(:question)) }

    context 'Authorized user' do
      before { log_in(user) }

      it 'destroys the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to the questions page' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end
    end

    context 'Unauthorized user' do
      let(:unauthorized_user) { create(:user) }

      before { log_in(unauthorized_user) }

      it 'does not destroy the question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end

      it 'redirects to the question page' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to question
      end
    end
  end
end
