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
    let!(:question) { create :question }
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

      describe 'comments' do
        let(:comments_list_size) { 5 }
        let!(:comments) { create_list :comment, comments_list_size, commentable: question }
        let(:received_comments) { json['question']['comments'] }

        it_behaves_like 'API Listable' do
          let(:list_name) { 'comments' }
        end

        it_behaves_like 'API Fieldable' do
          let(:fieldable) { question.comments.first }
          let(:received_fieldable) { json['question']['comments'].first }
          let(:public_fields) { %w[id text author_id created_at updated_at] }
          let(:private_fields) { %w[] }
        end
      end

      describe 'links' do
        let(:links_list_size) { 5 }
        let!(:links) { create_list :link, links_list_size, linkable: question }
        let(:received_links) { json['question']['links'] }

        it_behaves_like 'API Listable' do
          let(:list_name) { 'links' }
        end

        it_behaves_like 'API Fieldable' do
          let(:fieldable) { question.links.first }
          let(:received_fieldable) { json['question']['links'].first }
          let(:public_fields) { %w[id url name created_at updated_at] }
          let(:private_fields) { %w[] }
        end
      end

      describe 'files' do
        let!(:question) { create :question_with_files }
        let!(:files) { question.files }
        let(:received_files) { json['question']['files'] }
        let(:fieldable) { question.files.first }
        let(:received_fieldable) { json['question']['files'].first }

        it_behaves_like 'API Listable' do
          let(:list_name) { 'files' }
        end

        it_behaves_like 'API Fieldable' do
          let(:public_fields) { %w[id name created_at] }
          let(:private_fields) { %w[] }
        end

        it 'contails url field' do
          send api_method, api_path, params: { access_token: access_token.token }, headers: headers
          expect(received_fieldable['url']).to eq Rails.application.routes.url_helpers.polymorphic_url(fieldable, only_path: true)
        end
      end
    end
  end
end
