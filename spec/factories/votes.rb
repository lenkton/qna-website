FactoryBot.define do
  factory :vote do
    author
    question
    supportive { true }
  end
end
