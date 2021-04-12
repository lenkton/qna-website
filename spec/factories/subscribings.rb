FactoryBot.define do
  factory :subscribing do
    subscriber { association :user }
    subscription { association :question }
  end
end
