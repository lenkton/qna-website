module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable

    def rating
      votes.positive.count - votes.negative.count
    end

    def vote_of(user)
      votes.find_by(author_id: user)
    end
  end
end
