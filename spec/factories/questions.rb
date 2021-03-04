FactoryBot.define do
  sequence :question_body do |n|
    "question #{n} body"
  end

  sequence :question_title do |n|
    "question #{n} title"
  end

  factory :question do
    title { generate(:question_title) }
    body { generate(:question_body) }
    author
    best_answer { nil }

    trait :invalid do
      title { nil }
    end
  end
end
