require 'rails_helper'

RSpec.describe Subscribing, type: :model do
  it { should belong_to(:subscription) }
  it { should belong_to(:subscriber) }
  it { should have_db_index(%i[subscription_id subscriber_id]).unique(true) }
end
