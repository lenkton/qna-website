FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question
    author

    trait :invalid do
      body { nil }
    end
  end
end
