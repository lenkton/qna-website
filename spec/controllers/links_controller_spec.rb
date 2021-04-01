require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do
    let(:author) { create(:author) }
    let(:random_user) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let!(:link) { create :link, linkable: question }

    context 'Author of a resource' do
      before { log_in author }

      it 'deletes the link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to change(question.links, :count).by(-1)
      end

      it 'renders a destroy template' do
        delete :destroy, params: { id: link }, format: :js

        expect(response).to render_template(:destroy)
      end
    end
  end
end
