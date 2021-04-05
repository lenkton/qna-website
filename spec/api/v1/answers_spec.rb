require 'rails_helper'

describe 'Answers API', type: :request do
  let!(:question) { create :question }
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:api_method) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:access_token) { create :access_token }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:answers_list_size) { 3 }
      let!(:answers) { create_list :answer, answers_list_size, question: question }
      let(:answer) { answers.first }
      let(:received_answers) { json['answers'] }
      let(:received_answer) { received_answers.first }

      it_behaves_like 'API Fieldable' do
        let(:fieldable) { answer }
        let(:received_fieldable) { received_answer }
        let(:public_fields) { %w[id body author_id created_at updated_at] }
        let(:private_fields) { %w[links files comments] }
      end

      it_behaves_like 'API Listable' do
        let(:list_name) { 'answers' }
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let!(:answer) { create :answer_with_files }
    let(:api_method) { :get }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:access_token) { create :access_token }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:received_answer) { json['answer'] }

      it_behaves_like 'API Fieldable' do
        let(:fieldable) { answer }
        let(:received_fieldable) { received_answer }
        let(:public_fields) { %w[id body author_id created_at updated_at] }
        let(:private_fields) { %w[] }
      end

      it_behaves_like 'API Commentable' do
        let(:commentable) { answer }
        let(:received_commentable) { json['answer'] }
      end

      it_behaves_like 'API Linkable' do
        let(:linkable) { answer }
        let(:received_linkable) { json['answer'] }
      end

      it_behaves_like 'API Fileable' do
        let!(:fileable) { answer }
        let(:files) { fileable.files }
        let(:received_fileable) { json['answer'] }
      end
    end
  end
end
