require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewardings).dependent(:destroy) }
  it { should have_many(:rewards).through(:rewardings) }

  describe '#author_of?' do
    let(:author) { create(:user) }
    let(:random_user) { create(:user) }
    let(:question) { create(:question, author: author) }

    it 'returns true if the user is an author of the argument' do
      expect(author).to be_author_of(question)
    end

    it 'returns false if the user is not an author of the argument' do
      expect(random_user).not_to be_author_of(question)
    end
  end
end
