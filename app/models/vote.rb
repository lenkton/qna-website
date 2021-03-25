class Vote < ApplicationRecord
  include Authorable

  belongs_to :votable, polymorphic: true

  validates :value, inclusion: { in: [1, -1] }
  validate :validate_self_voting

  scope :positive, -> { where('value > 0') }
  scope :negative, -> { where('value < 0') }

  private

  def validate_self_voting
    if author&.author_of?(votable)
      errors.add(:author, I18n.t('votes.errors.self_voting'))
    end
  end
end
