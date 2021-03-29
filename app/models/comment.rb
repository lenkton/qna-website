class Comment < ApplicationRecord
  include Authorable

  belongs_to :question

  validates :text, presence: true
end
