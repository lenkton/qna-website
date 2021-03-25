class Answer < ApplicationRecord
  include Authorable
  include Votable

  belongs_to :question
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  def choose_best!
    transaction do
      question.update!(best_answer_id: id)
      author.rewards << question.reward
    end
  end
end
