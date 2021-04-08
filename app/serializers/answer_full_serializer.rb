class AnswerFullSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :author_id
  has_many :files
  has_many :links
  has_many :comments
end
