class Question < ApplicationRecord
  include Authorable
  include Votable
  include Commentable
  include Linkable
  include Fileable
  include Rewardable

  has_many :answers, dependent: :destroy
  has_many :subscribings, dependent: :destroy, foreign_key: :subscription_id
  has_many :subscribers, through: :subscribings

  belongs_to :best_answer, class_name: 'Answer', optional: true

  validates :title, :body, presence: true
  validate :validate_best_answer_in_answers

  after_create do
    subscribers.push(author)
  end

  private

  def validate_best_answer_in_answers
    return if best_answer_id.nil? || answer_ids.include?(best_answer_id)

    errors.add(:best_answer, I18n.t('questions.errors.not_in_answers'))
  end
end
