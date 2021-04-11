require 'rails_helper'

RSpec.describe SubscribingsController, type: :controller do
  let(:user) { create :user }
  let!(:question) { create :question }
  let(:format) { :json }

  describe 'POST #create' do
    before { log_in(user) }

    it_behaves_like 'Controller Createable', :subscribing do
      let(:success_response) { satisfy { response.body == Subscribing.last.to_json(root: 'subscribing') } }
      let(:additional_params) { { question_id: question.id } }
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscribing) { create :subscribing, subscriber: user }

    before { log_in(user) }

    it_behaves_like 'Controller Deleteable', :subscribing do
      let(:success_response) { be_successful }
    end
  end
end
