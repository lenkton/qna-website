FactoryBot.define do
  factory :vote do
    author
    votable { association :question }
    supportive { true }
  end
end
