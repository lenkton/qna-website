class User < ApplicationRecord
  has_many :questions, dependent: :destroy, foreign_key: :author_id
  has_many :answers, dependent: :destroy, foreign_key: :author_id
  has_many :rewardings, dependent: :destroy
  has_many :rewards, through: :rewardings
  has_many :votes, dependent: :destroy, foreign_key: :author_id

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(resource)
    resource.author_id == id
  end
end
