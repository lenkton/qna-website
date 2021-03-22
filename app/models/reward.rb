class Reward < ApplicationRecord
  has_many :rewardings, dependent: :destroy
  belongs_to :question

  has_one_attached :image

  validates :name, :image, presence: true
end
