require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it 'validates format of the URL' do
    expect(build(:link, url: 'not_a_url')).not_to be_valid
  end
end
