require 'rails_helper'

RSpec.describe Comment, type: :model do
  it_behaves_like 'authorable'

  it { should belong_to :question }

  it { should validate_presence_of(:text) }
end
