class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :question

  scope :positive, -> { where(supportive: true) }
  scope :negative, -> { where(supportive: false) }
end
