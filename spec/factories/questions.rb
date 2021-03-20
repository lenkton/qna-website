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

    factory :question_with_files do
      after(:create) do |question, evaluator|
        question.files.attach(io: File.open('Gemfile'), filename: 'Gemfile')
        question.files.attach(io: File.open('Gemfile.lock'), filename: 'Gemfile.lock')

        question.reload
      end
    end

    factory :question_with_reward do
      reward { build :reward }
    end
  end
end
