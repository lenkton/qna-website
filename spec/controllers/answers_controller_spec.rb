require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let!(:question){ create(:question) }

    context 'valid parameters' do
      it 'creates an answer for the question in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to the question' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }

        expect(response).to redirect_to(question)
      end
    end

    context 'invalid parameters' do
      it 'does not create an answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(Answer, :count)
      end

      it 'renders the new veiw' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }

        expect(response).to render_template(:new)
      end
    end
  end
end
