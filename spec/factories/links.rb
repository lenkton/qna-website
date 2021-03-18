FactoryBot.define do
  sequence :link_url do |n|
    "site#{n}.com"
  end

  sequence :link_name do |n|
    "Site #{n}"
  end

  factory :link do
    name { generate(:link_url) }
    url { generate(:link_name) }
    linkable { association :question }
  end
end
