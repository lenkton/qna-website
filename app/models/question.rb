class Question < ApplicationRecord
  include Authorable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :votes, dependent: :destroy
  has_one :reward, dependent: :destroy

  belongs_to :best_answer, class_name: 'Answer', optional: true

  has_many_attached :files

  accepts_nested_attributes_for :links, :reward, reject_if: :all_blank

  validates :title, :body, presence: true
  validate :validate_best_answer_in_answers

  def rating
    votes.positive.count - votes.negative.count
  end

  def vote_of(user)
    votes.find_by(author_id: user)
  end

  private

  def validate_best_answer_in_answers
    return if best_answer_id.nil? || answer_ids.include?(best_answer_id)

    errors.add(:best_answer, I18n.t('questions.errors.not_in_answers'))
  end
end
