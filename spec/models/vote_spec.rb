require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  it { should have_db_index(%i[user_id question_id]).unique(true) }

  describe '::positive' do
    it "returns the scope of 'for' votes" do
      expect(Vote.positive).to eq Vote.where(supportive: true)
    end
  end

  describe '::negative' do
    it "returns the scope of 'against' votes" do
      expect(Vote.negative).to eq Vote.where(supportive: false)
    end
  end
end
