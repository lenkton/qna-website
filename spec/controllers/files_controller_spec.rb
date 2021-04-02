require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  describe 'DELETE #destroy' do
    let(:author) { create(:author) }
    let(:random_user) { create(:user) }
    let!(:question) { create(:question_with_files, author: author) }
    let(:file) { question.files.first }

    context 'Author of a resource' do
      before { log_in author }

      it 'purges the file' do
        expect { delete :destroy, params: { id: file }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'renders a destroy template' do
        delete :destroy, params: { id: file }, format: :js

        expect(response).to render_template(:destroy)
      end
    end
  end
end
