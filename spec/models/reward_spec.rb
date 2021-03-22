require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should have_many(:rewardings).dependent(:destroy) }
  it { should belong_to(:question) }
  it { should have_one_attached(:image) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:image) }
end
