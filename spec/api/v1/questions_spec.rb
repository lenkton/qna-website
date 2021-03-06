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
        let(:received_fileable) { received_question }
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:api_method) { :post }
    let(:api_path) { '/api/v1/questions' }
    let(:access_token) { create :access_token }
    let(:question_params) { attributes_for :question, author_id: access_token.resource_owner_id, links_attributes: attributes_for_list(:link, 5) }
    let(:additional_params) { { question: question_params } }
    let(:question) { Question.last }
    let(:links) { question.links }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'valid params' do
        let(:received_question) { json['question'] }

        it_behaves_like 'API Fieldable' do
          let(:public_fields) { %w[id title body author_id created_at updated_at] }
          let(:received_fieldable) { json['question'] }
          let(:fieldable) { question }
        end

        it_behaves_like 'API Linkable' do
          let(:linkable) { question }
          let(:received_linkable) { received_question }
        end
      end

      it_behaves_like 'API Invalidable' do
        let(:invalid_params) { { question: attributes_for(:question, :invalid) } }
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:api_method) { :patch }
    let(:api_path) { "/api/v1/questions/#{old_question.id}" }
    let(:access_token) { create :access_token }
    let(:question_params) { attributes_for :question, author_id: access_token.resource_owner_id, links_attributes: attributes_for_list(:link, 5) }
    let(:additional_params) { { question: question_params } }
    let(:old_question) { create :question, author_id: access_token.resource_owner_id }
    let(:question) { old_question.reload }
    let(:links) { question.links }

    it_behaves_like 'API Authorizable'

    context 'random user' do
      let(:random_access_token) { create :access_token }

      it 'returns unauthorized error' do
        patch api_path, params: { access_token: random_access_token.token, question: question_params }, headers: headers
        expect(response).to be_unauthorized
      end
    end

    context 'authorized' do
      context 'valid params' do
        let(:received_question) { json['question'] }

        it_behaves_like 'API Fieldable' do
          let(:public_fields) { %w[id title body author_id created_at updated_at] }
          let(:received_fieldable) { json['question'] }
          let(:fieldable) { question }
        end

        it_behaves_like 'API Linkable' do
          let(:linkable) { question }
          let(:received_linkable) { received_question }
        end
      end

      it_behaves_like 'API Invalidable' do
        let(:invalid_params) { { question: attributes_for(:question, :invalid) } }
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:api_method) { :delete }
    let(:api_path) { "/api/v1/questions/#{old_question.id}" }
    let(:access_token) { create :access_token }
    let!(:old_question) { create :question, author_id: access_token.resource_owner_id }

    it_behaves_like 'API Authorizable'

    context 'random user' do
      let(:random_access_token) { create :access_token }

      it 'returns unauthorized error' do
        delete api_path, params: { access_token: random_access_token.token }, headers: headers
        expect(response).to be_unauthorized
      end
    end

    context 'authorized' do
      it 'actually deletes a question' do
        expect { delete api_path, params: { access_token: access_token.token }, headers: headers }
          .to change(Question, :count).by(-1)
      end
    end
  end
end
