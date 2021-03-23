class Vote < ApplicationRecord
  include Authorable

  belongs_to :question

  scope :positive, -> { where(supportive: true) }
  scope :negative, -> { where(supportive: false) }
end
