require 'rails_helper'

RSpec.shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  describe '#rating' do
    let(:votable) { create described_class.to_s.underscore.to_sym }
    let!(:votes_for) { create_list :vote, 5, votable: votable, value: 1 }
    let!(:votes_against) { create_list :vote, 2, votable: votable, value: -1 }

    it 'returns the number of votes for minus the number of votes against the votable' do
      expect(votable.rating).to eq(votes_for.count - votes_against.count)
    end
  end

  describe '#vote_of(author)' do
    let(:author) { create :author }

    context 'the Vote exists' do
      let!(:vote) { create :vote, author: author }

      it 'returns the Vote of the specified author for/against the quesiton' do
        expect(vote.votable.vote_of(author)).to eq vote
      end
    end

    context 'the Vote does not exist' do
      it 'returns nil' do
        expect(described_class.new.vote_of(author)).to be_nil
      end
    end
  end
end
