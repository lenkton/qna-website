require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, User }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:random_user) { create :user }

    it { should_not be_able_to :manage, :all }

    # Answers
    it { should be_able_to :read, Answer }
    it { should be_able_to :create, Answer }
    it { should be_able_to :update, create(:answer, author: user) }
    it { should_not be_able_to :update, create(:answer, author: random_user) }
    it { should be_able_to :destroy, create(:answer, author: user) }
    it { should_not be_able_to :destroy, create(:answer, author: random_user) }

    # Comments
    it { should be_able_to :read, Comment }
    it { should be_able_to :create, Comment }

    # Links
    it { should be_able_to :read, Link }
    it { should be_able_to :destroy, create(:link, linkable: create(:question, author: user)) }
    it { should_not be_able_to :destroy, create(:link, linkable: create(:question, author: random_user)) }

    # Votes
    it { should be_able_to :create, Vote }
    it { should be_able_to :destroy, create(:vote, author: user) }
    it { should_not be_able_to :destroy, create(:vote, author: random_user) }

    # Questions
    it { should be_able_to :read, Question }
    it { should be_able_to :create, Question }
    it { should be_able_to :set_best_answer, create(:question, author: user) }
    it { should_not be_able_to :set_best_answer, create(:question, author: random_user) }
    it { should be_able_to :update, create(:question, author: user) }
    it { should_not be_able_to :update, create(:question, author: random_user) }
    it { should be_able_to :destroy, create(:question, author: user) }
    it { should_not be_able_to :destroy, create(:question, author: random_user) }

    # Subscribings
    it { should be_able_to :create, Subscribing }
    it { should be_able_to :destroy, create(:subscribing, subscriber: user) }
    it { should_not be_able_to :destroy, create(:subscribing, subscriber: random_user) }

    # Files
    it { should be_able_to :read, File }
    it { should be_able_to :destroy, create(:question_with_files, author: user).files.first }
    it { should_not be_able_to :destroy, create(:question_with_files, author: random_user).files.first }

    # Users
    it { should be_able_to :read, User }
    it { should be_able_to :me, User }
  end
end
