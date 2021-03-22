FactoryBot.define do
  sequence :link_url do |n|
    "https://site#{n}.com"
  end

  sequence :link_name do |n|
    "Site #{n}"
  end

  factory :link do
    name { generate(:link_name) }
    url { generate(:link_url) }
    linkable { association :question }
  end
end
