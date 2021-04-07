require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:author) { create(:author) }
  let(:random_user) { create(:user) }

  describe 'POST #create' do
    before { log_in(author) }

    it_behaves_like 'Controller Createable', :question

    context 'valid parameters' do
      let(:question_attributes) { attributes_for(:question) }

      it 'redirects to the question' do
        post :create, params: { question: question_attributes }

        expect(response).to redirect_to(Question.find_by(title: question_attributes[:title]))
      end

      it 'broadcasts the question to the questions_channel' do
        expect { post :create, params: { question: attributes_for(:question) } }
          .to(have_broadcasted_to('questions_channel').with { |data| expect(data.to_json).to eq Question.last.to_json })
      end
    end

    context 'invalid parameters' do
      it 'renders the new veiw' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to render_template(:new)
      end

      it 'broadcasts no question to the questions_channel' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }
          .not_to have_broadcasted_to('questions_channel')
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
      it 'renders the update template' do
        log_in(random_user)
        patch :update, params: { id: question, question: new_values }, format: :js

        expect(response).to render_template(:update)
      end
    end
  end

  describe 'POST #set_best_answer' do
    let!(:question) { create(:question, author: author, reward: build(:reward)) }
    let!(:answer) { create(:answer, question: question) }

    context 'Author' do
      before { log_in author }

      context 'valid params' do
        before { post :set_best_answer, params: { id: question, answer_id: answer }, format: :js }

        it 'set the passed answer as the best' do
          question.reload
          expect(question.best_answer).to eq answer
        end

        it 'renders set_best_answer template' do
          expect(response).to render_template :set_best_answer
        end

        it 'grants a reward to the author of the best answer' do
          expect(answer.author.rewards).to include(question.reward)
        end
      end

      context 'invalid params' do
        let(:random_answer) { create(:answer) }
        let!(:original_best_answer) { question.best_answer }

        before { post :set_best_answer, params: { id: question, answer_id: random_answer }, format: :js }

        it 'does not change the best answer' do
          question.reload
          expect(question.best_answer).to eq original_best_answer
        end

        it 'renders set_best_answer template' do
          expect(response).to render_template :set_best_answer
        end
      end
    end

    context 'Random user' do
      let!(:original_best_answer) { question.best_answer }

      it 'renders set_best_answer template' do
        log_in random_user
        post :set_best_answer, params: { id: question, answer_id: answer }, format: :js

        expect(response).to render_template :set_best_answer
      end
    end
  end
end
