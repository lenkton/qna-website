FactoryBot.define do
  sequence :uid, &:to_s

  factory :oauth_application, class: 'Doorkeeper::Application' do
    name { 'Test' }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    uid { generate :uid }
    secret { '87654321' }
  end
end
