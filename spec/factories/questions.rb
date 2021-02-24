FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    author

    trait :invalid do
      title { nil }
    end
  end
end
