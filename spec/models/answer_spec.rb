require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :author }
  it { should have_many(:links).dependent(:destroy) }

  it 'has many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of :body }

  describe '#choose_best!' do
    let(:question) { create :question, reward: create(:reward) }
    let(:answer) { create :answer, question: question }

    before { answer.choose_best! }

    it "sets the question's best answer to the answer" do
      expect(answer.question.best_answer).to eq answer
    end

    it "grants the question's reward to the answer's author" do
      expect(answer.author.rewards).to include(question.reward)
    end
  end
end
