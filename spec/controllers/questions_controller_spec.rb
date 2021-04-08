require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:author) { create(:author) }
  let(:random_user) { create(:user) }

  describe 'POST #create' do
    before { log_in(author) }

    it_behaves_like 'Controller Createable', :question do
      let(:success_response) { redirect_to(Question.last) }
      let(:failure_response) { render_template(:new) }
    end

    it_behaves_like 'Controller Broadcastable', :question do
      let(:channel_name) { 'questions_channel' }
      let(:expected_response) { Question.last.as_json }
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { author.questions.create(attributes_for(:question)) }

    context 'Author' do
      before { log_in(author) }

      it_behaves_like 'Controller Deleteable', :question do
        let(:success_response) { redirect_to questions_path }
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
    context 'Author' do
      before { log_in(author) }

      it_behaves_like 'Controller Updateable', :question do
        let(:format) { :js }
        let(:success_response) { render_template(:update) }
        let(:failure_response) { render_template(:update) }
      end
    end

    context 'Random user' do
      let!(:question) { create(:question, author: author) }

      it 'renders the update template' do
        log_in(random_user)
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js

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
