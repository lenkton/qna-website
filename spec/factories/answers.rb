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

    factory :answer_with_files do
      after(:create) do |answer, evaluator|
        answer.files.attach(io: File.open('Gemfile'), filename: 'Gemfile')
        answer.files.attach(io: File.open('Gemfile.lock'), filename: 'Gemfile.lock')

        answer.reload
      end
    end
  end
end
