require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:me) { create :user }
  let(:access_token) { create :access_token, resource_owner_id: me.id }
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/profiles/me' do
    let(:api_method) { :get }
    let(:api_path) { '/api/v1/profiles/me' }
    let(:received_user) { json['user'] }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(received_user[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted].each do |attr|
          expect(received_user).not_to have_key(attr)
        end
      end
    end
  end
end
