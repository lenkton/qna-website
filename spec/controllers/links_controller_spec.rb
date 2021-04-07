require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do
    let(:author) { create(:author) }
    let(:random_user) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let!(:link) { create :link, linkable: question }

    context 'Author of a resource' do
      before { log_in author }

      it_behaves_like 'Controller Deleteable', :link do
        let(:success_response) { render_template(:destroy) }
        let(:format) { :js }
      end
    end
  end
end
