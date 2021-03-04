class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_one :best_answer, dependent: :destroy, class_name: 'Answer'

  belongs_to :author, class_name: 'User'

  validates :title, :body, presence: true
end
