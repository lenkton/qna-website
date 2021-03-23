class Vote < ApplicationRecord
  include Authorable

  belongs_to :votable, polymorphic: true

  scope :positive, -> { where(supportive: true) }
  scope :negative, -> { where(supportive: false) }
end
