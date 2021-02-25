FactoryBot.define do
  sequence :answer_body do |n|
    "answer #{n} body"
  end

  factory :answer do
    body { generate(:answer_body) }
    question
    author

    trait :invalid do
      body { nil }
    end
  end
end
