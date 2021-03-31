FactoryBot.define do
  sequence :comment_text do |n|
    "comment #{n} text"
  end

  factory :comment do
    text { generate :comment_text }
    commentable { association :answer }
    author

    trait :invalid do
      text { nil }
    end
  end
end
