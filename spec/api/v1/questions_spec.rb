require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    let(:api_method) { :get }
    let(:api_path) { '/api/v1/questions' }
    let(:access_token) { create :access_token }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:questions_list_size) { 3 }
      let!(:questions) { create_list :question, questions_list_size }
      let(:question) { questions.first }
      let(:recieved_questions) { json['questions'] }
      let(:recieved_question) { recieved_questions.first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns a list of questions' do
        expect(recieved_questions.size).to eq questions_list_size
      end

      it 'returns all public fields' do
        %w[id title body author_id created_at updated_at].each do |attr|
          expect(recieved_question[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end
end
