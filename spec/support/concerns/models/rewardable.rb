require 'rails_helper'

RSpec.shared_examples_for 'rewardable' do
  it { should have_one(:reward).dependent(:destroy) }
  it { should accept_nested_attributes_for :reward }
end
