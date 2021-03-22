FactoryBot.define do
  sequence :reward_name do |n|
    "Reward #{n} name"
  end

  sequence :image_name do |n|
    "image#{n}.bmp"
  end

  factory :reward do
    question
    name { generate(:reward_name) }

    after(:build) do |reward, evaluator|
      reward.image.attach(io: File.open("#{Rails.root}/spec/fixtures/files/colors.bmp"), filename: generate(:image_name))
    end
  end
end
