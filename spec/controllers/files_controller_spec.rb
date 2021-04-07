require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  describe 'DELETE #destroy' do
    let(:author) { create(:author) }
    let(:random_user) { create(:user) }
    let!(:question) { create(:question_with_files, author: author) }
    let(:file) { question.files.first }

    context 'Author of a resource' do
      before { log_in author }

      it_behaves_like 'Controller Deleteable', :file do
        let(:success_response) { render_template(:destroy) }
        let(:format) { :js }
        let(:scope) { question.files }
      end
    end
  end
end
