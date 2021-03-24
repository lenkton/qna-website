class Vote < ApplicationRecord
  include Authorable

  belongs_to :votable, polymorphic: true

  scope :positive, -> { where(supportive: true) }
  scope :negative, -> { where(supportive: false) }

  validate :validate_self_voting

  private

  def validate_self_voting
    if author&.author_of?(votable)
      errors.add(:author, I18n.t('votes.errors.self_voting'))
    end
  end
end
