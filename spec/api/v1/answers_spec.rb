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
      let!(:random_answers) { create_list :answer, 2 }
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

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:api_method) { :post }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:access_token) { create :access_token }
    let(:answer_params) { attributes_for :answer, author_id: access_token.resource_owner_id, links_attributes: attributes_for_list(:link, 5)}
    let(:additional_params) { { answer: answer_params } }
    let(:answer) { Answer.last }
    let(:links) { answer.links }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'valid params' do
        let(:received_answer) { json['answer'] }

        it_behaves_like 'API Fieldable' do
          let(:public_fields) { %w[id body author_id created_at updated_at] }
          let(:received_fieldable) { json['answer'] }
          let(:fieldable) { answer }
        end

        it_behaves_like 'API Linkable' do
          let(:linkable) { answer }
          let(:received_linkable) { received_answer }
        end
      end

      it_behaves_like 'API Invalidable' do
        let(:invalid_params) { { answer: attributes_for(:answer, :invalid) } }
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:api_method) { :patch }
    let(:api_path) { "/api/v1/answers/#{old_answer.id}" }
    let(:access_token) { create :access_token }
    let(:answer_params) { attributes_for :answer, author_id: access_token.resource_owner_id, links_attributes: attributes_for_list(:link, 5) }
    let(:additional_params) { { answer: answer_params } }
    let(:old_answer) { create :answer, author_id: access_token.resource_owner_id }
    let(:answer) { old_answer.reload }
    let(:links) { answer.links }

    it_behaves_like 'API Authorizable'

    context 'random user' do
      let(:random_access_token) { create :access_token }

      it 'returns unauthorized error' do
        patch api_path, params: { access_token: random_access_token.token, answer: answer_params }, headers: headers
        expect(response).to be_unauthorized
      end
    end

    context 'authorized' do
      context 'valid params' do
        let(:received_answer) { json['answer'] }

        it_behaves_like 'API Fieldable' do
          let(:public_fields) { %w[id body author_id created_at updated_at] }
          let(:received_fieldable) { json['answer'] }
          let(:fieldable) { answer }
        end

        it_behaves_like 'API Linkable' do
          let(:linkable) { answer }
          let(:received_linkable) { received_answer }
        end
      end

      it_behaves_like 'API Invalidable' do
        let(:invalid_params) { { answer: attributes_for(:answer, :invalid) } }
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:api_method) { :delete }
    let(:api_path) { "/api/v1/answers/#{old_answer.id}" }
    let(:access_token) { create :access_token }
    let!(:old_answer) { create :answer, author_id: access_token.resource_owner_id }

    it_behaves_like 'API Authorizable'

    context 'random user' do
      let(:random_access_token) { create :access_token }

      it 'returns unauthorized error' do
        delete api_path, params: { access_token: random_access_token.token }, headers: headers
        expect(response).to be_unauthorized
      end
    end

    context 'authorized' do
      it 'actually deletes a answer' do
        expect { delete api_path, params: { access_token: access_token.token }, headers: headers }
          .to change(Answer, :count).by(-1)
      end
    end
  end
end
