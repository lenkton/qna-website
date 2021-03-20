FactoryBot.define do
  sequence :reward_name do |n|
    "Reward #{n} name"
  end

  factory :reward do
    question
    name { generate(:reward_name) }

    after(:build) do |reward, evaluator|
      reward.image.attach(io: File.open('Gemfile'), filename: 'Gemfile')
    end
  end
end
