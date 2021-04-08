require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:me) { create :user }
  let(:access_token) { create :access_token, resource_owner_id: me.id }
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end
  let(:public_fields) { %w[id email admin created_at updated_at] }
  let(:private_fields) { %w[password encrypted] }

  describe 'GET /api/v1/profiles/me' do
    let(:api_method) { :get }
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      it_behaves_like 'API Fieldable' do
        let(:fieldable) { me }
        let(:received_fieldable) { json['user'] }
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_method) { :get }
    let(:api_path) { '/api/v1/profiles' }
    let!(:users) { create_list :user, users_list_size }
    let(:users_list_size) { 5 }
    let(:me) { users.first }
    let(:random_user) { users.third }
    let(:received_random_user) { json['users'].second }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      it_behaves_like 'API Fieldable' do
        let(:fieldable) { random_user }
        let(:received_fieldable) { received_random_user }
      end

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns the list of all users except for the user' do
        expect(json['users'].size).to eq(users.size - 1)
      end
    end
  end
end
