require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:author) { create(:author) }
  let(:random_user) { create(:user) }

  describe 'POST #create' do
    before { log_in(author) }

    context 'valid parameters' do
      it 'creates a question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      let(:question_attributes) { attributes_for(:question) }

      it 'redirects to the question' do
        post :create, params: { question: question_attributes }

        expect(response).to redirect_to(Question.find_by(question_attributes))
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
    let!(:question) { author.questions.create(attributes_for(:question)) }

    context 'Author' do
      before { log_in(author) }

      it 'destroys the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to the questions page' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end
    end

    context 'Random user' do
      before { log_in(random_user) }

      it 'does not destroy the question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end

      it 'redirects to the question page' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to question
      end
    end

    context 'Unauthenticated user' do
      it 'does not destroy the question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end

      it 'redirects to the question page' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to question
      end
    end
  end

  describe 'PATCH #update' do
    let(:old_values) { { title: 'old title', body: 'old body' } }
    let(:new_values) { { title: 'new title', body: 'new body' } }
    let!(:question) { create(:question, author: author, title: old_values[:title], body: old_values[:body]) }

    context 'Author' do
      before { log_in(author) }

      context 'with valid parameters' do
        before { patch :update, params: { id: question, question: new_values }, format: :js }

        it 'updates the question' do
          question.reload

          expect(question.body).to eq new_values[:body]
          expect(question.title).to eq new_values[:title]
        end

        it 'renders the update template' do
          expect(response).to render_template(:update)
        end
      end

      context 'with invalid parameters' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

        it 'does not change the question' do
          question.reload

          expect(question.body).to eq old_values[:body]
          expect(question.title).to eq old_values[:title]
        end

        it 'renders the update template' do
          expect(response).to render_template(:update)
        end
      end
    end

    context 'Random user' do
      before do
        log_in(random_user)
        patch :update, params: { id: question, question: new_values }, format: :js
      end

      it 'does not change the question' do
        question.reload

        expect(question.body).to eq old_values[:body]
        expect(question.title).to eq old_values[:title]
      end

      it 'renders the update template' do
        expect(response).to render_template(:update)
      end
    end

    context 'Unauthenticated user' do
      before { patch :update, params: { id: question, question: new_values }, format: :js }

      it 'does not change the question' do
        question.reload

        expect(question.body).to eq old_values[:body]
        expect(question.title).to eq old_values[:title]
      end

      it 'renders the update template' do
        expect(response).to render_template(:update)
      end
    end
  end
end
