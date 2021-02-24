require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  describe '#author_of?' do
    let(:author) { create(:user) }
    let(:random_user) { create(:user) }

    context 'the argument is a question' do
      let(:question) { create(:question, author: author) }

      it 'returns true if the user is an author of the argument' do
        expect(author.author_of?(question)).to eq(true)
      end

      it 'returns false if the user is not an author of the argument' do
        expect(random_user.author_of?(question)).to eq(false)
      end
    end

    context 'the argument is an answer' do
      let(:answer) { create(:answer, author: author) }

      it 'returns true if the user is an author of the argument' do
        expect(author.author_of?(answer)).to eq(true)
      end

      it 'returns false if the user is not an author of the argument' do
        expect(random_user.author_of?(answer)).to eq(false)
      end
    end
  end
end
