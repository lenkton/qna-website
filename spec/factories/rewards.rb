FactoryBot.define do
  sequence :reward_name do |n|
    "Reward #{n} name"
  end

  factory :reward do
    question
    name { generate(:reward_name) }
  end
end
