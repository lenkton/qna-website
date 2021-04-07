FactoryBot.define do
  factory :vote do
    author
    votable { association :question }
    value { 1 }

    trait :invalid do
      value { nil }
    end
  end
end
