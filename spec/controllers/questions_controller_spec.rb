require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }

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
end
