require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should belong_to(:best_answer).optional }

  it { should belong_to :author }

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it 'validates that the best answer is present among the answers' do
    expect(build(:question, best_answer: create(:answer))).to_not be_valid
  end

  describe '#rating' do
    let(:question) { create :question }
    let!(:votes_for) { create_list :vote, 5, question: question, supportive: true }
    let!(:votes_against) { create_list :vote, 2, question: question, supportive: false }

    it 'returns the number of votes for minus the number of votes against the question' do
      expect(question.rating).to eq(votes_for.count - votes_against.count)
    end
  end

  describe '#vote_of(user)' do
    let(:user) { create :user }

    context 'the Vote exists' do
      let!(:vote) { create :vote, user: user }

      it 'returns the Vote of the specified user for/against the quesiton' do
        expect(vote.question.vote_of(user)).to eq vote
      end
    end

    context 'the Vote does not exist' do
      it 'returns nil' do
        expect(Question.new.vote_of(user)).to be_nil
      end
    end
  end
end
