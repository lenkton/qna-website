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

  describe 'DELETE #purge_file' do
    let!(:answer) { create(:answer_with_files, author: author) }
    let(:file) { answer.files.first }

    context 'Author' do
      before { log_in author }

      context 'with valid params' do
        it 'purges a file' do
          expect { delete :purge_file, params: { id: answer, file_id: file }, format: :js }.to change(answer.files, :count).by(-1)
        end

        it 'renders a purge_file template' do
          delete :purge_file, params: { id: answer, file_id: file }, format: :js

          expect(response).to render_template :purge_file
        end
      end
      
      context 'with invalid params' do
        let(:random_file) { create(:answer_with_files).files.first }

        it 'purges no file' do
          expect { delete :purge_file, params: { id: answer, file_id: random_file }, format: :js }.not_to change(answer.files, :count)
        end

        it 'renders a purge_file template' do
          delete :purge_file, params: { id: answer, file_id: random_file }, format: :js

          expect(response).to render_template :purge_file
        end
      end
    end

    context 'Random user' do
      before { log_in random_user }

      it 'purges no file' do
        expect { delete :purge_file, params: { id: answer, file_id: file }, format: :js }.not_to change(answer.files, :count)
      end

      it 'renders a purge_file template' do
        delete :purge_file, params: { id: answer, file_id: file }, format: :js

        expect(response).to render_template :purge_file
      end
    end
  end
end
