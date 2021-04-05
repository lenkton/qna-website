require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  let(:fieldable) { question }
  let(:received_fieldable) { received_question }

  describe 'GET /api/v1/questions' do
    let(:api_method) { :get }
    let(:api_path) { '/api/v1/questions' }
    let(:access_token) { create :access_token }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:questions_list_size) { 3 }
      let!(:questions) { create_list :question, questions_list_size }
      let(:question) { questions.first }
      let(:received_questions) { json['questions'] }
      let(:received_question) { received_questions.first }

      it_behaves_like 'API Fieldable' do
        let(:public_fields) { %w[id title body author_id created_at updated_at] }
        let(:private_fields) { %w[links files comments] }
      end

      it_behaves_like 'API Listable' do
        let(:list_name) { 'questions' }
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create :question_with_files }
    let(:api_method) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:access_token) { create :access_token }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:received_question) { json['question'] }

      it_behaves_like 'API Fieldable' do
        let(:public_fields) { %w[id title body author_id created_at updated_at] }
        let(:private_fields) { %w[] }
      end

      it_behaves_like 'API Commentable' do
        let(:commentable) { question }
        let(:received_commentable) { received_question }
      end

      it_behaves_like 'API Linkable' do
        let(:linkable) { question }
        let(:received_linkable) { received_question }
      end

      it_behaves_like 'API Fileable' do
        let!(:fileable) { question }
        let(:files) { fileable.files }
        let(:received_fileable) { received_question}
      end
    end
  end
end
