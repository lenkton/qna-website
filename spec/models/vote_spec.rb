require 'rails_helper'

RSpec.describe Vote, type: :model do
  it_behaves_like 'authorable'

  it { should belong_to(:votable) }

  it { should have_db_index(%i[author_id votable_id votable_type]).unique(true) }

  it { should validate_inclusion_of(:value).in_array([1, -1]) }

  let(:author) { create :author }
  let(:question) { create :question, author: author }

  it 'validates that the author of a votable does not vote for himeself/herself' do
    expect(Vote.new(votable: question, author: author)).not_to be_valid
  end

  describe 'scopes' do
    let!(:positive_votes) { create_list :vote, 5, value: 1 }
    let!(:negative_votes) { create_list :vote, 2, value: -1 }

    describe '::positive' do
      it "returns the scope of 'for' votes" do
        expect(Vote.positive).to eq Vote.where('value > 0')
      end
    end

    describe '::negative' do
      it "returns the scope of 'against' votes" do
        expect(Vote.negative).to eq Vote.where('value < 0')
      end
    end
  end
end
