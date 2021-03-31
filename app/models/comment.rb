class Comment < ApplicationRecord
  include Authorable

  belongs_to :commentable, polymorphic: true

  validates :text, presence: true
end
