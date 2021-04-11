require 'rails_helper'

RSpec.describe SubscribingsController, type: :controller do
  let(:user) { create :user }
  let!(:question) { create :question }

  describe 'POST #create' do
    before { log_in(user) }

    it_behaves_like 'Controller Createable', :subscribing do
      let(:format) { :json }
      let(:success_response) { be_successful }
      let(:additional_params) { { question_id: question.id } }
    end
  end
end
