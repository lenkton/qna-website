FactoryBot.define do
  factory :vote do
    author
    votable { association :question }
    value { 1 }
  end
end
