require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:best_answer).optional }

  it { should belong_to :author }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it 'validates that the best answer is present among the answers' do
    expect(build(:question, best_answer: create(:answer))).to_not be_valid
  end
end
