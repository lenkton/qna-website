require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:author) { create(:author) }
  let(:random_user) { create(:user) }
  let(:gist_url) { 'https://gist.github.com/lenkton/99b9323cc3f01e1d4931486bd65195c4' }
  let(:format) { :js }

  describe 'POST #create' do
    let!(:question) { create(:question) }
    let(:additional_params) { { question_id: question } }

    before { log_in(author) }

    it_behaves_like 'Controller Createable', :answer do
      let(:success_response) { render_template(:create) }
      let(:failure_response) { render_template(:create) }
    end

    it_behaves_like 'Controller Broadcastable', :answer do
      let(:channel_name) { AnswersChannel.broadcasting_for(question) }
      let(:expected_response) { { answer: Answer.last, links: [], files: [], rating: 0 }.as_json }
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, author: author, question: question) }
    let(:controller_method) { :delete }
    let(:controller_action) { :destroy }

    context 'Author' do
      before { log_in(author) }

      it_behaves_like 'Controller Deleteable', :answer do
        let(:success_response) { render_template(:destroy) }
      end
    end
  end

  describe 'PATCH #update' do
    context 'Author' do
      before { log_in(author) }

      it_behaves_like 'Controller Updateable', :answer do
        let(:success_response) { render_template(:update) }
        let(:failure_response) { render_template(:update) }
      end
    end
  end
end
