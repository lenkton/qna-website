FactoryBot.define do
  factory :vote do
    user
    question
    supportive { true }
  end
end
