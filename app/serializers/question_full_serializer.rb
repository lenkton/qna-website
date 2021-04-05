class QuestionFullSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :author_id
  has_many :files
  has_many :links
  has_many :comments
end
