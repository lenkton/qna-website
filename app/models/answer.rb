class Answer < ApplicationRecord
  include Authorable
  include Votable
  include Commentable
  include Linkable
  include Fileable

  belongs_to :question

  validates :body, presence: true

  after_create do
    NotificationJob.perform_later(self)
  end

  def choose_best!
    transaction do
      question.update!(best_answer_id: id)
      author.rewards << question.reward
    end
  end
end
