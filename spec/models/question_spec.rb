require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'authorable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should belong_to(:best_answer).optional }

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it 'validates that the best answer is present among the answers' do
    expect(build(:question, best_answer: create(:answer))).to_not be_valid
  end
end
