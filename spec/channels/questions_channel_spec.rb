require 'rails_helper'

RSpec.describe QuestionsChannel, type: :channel do
  it 'successfully subscribes and transmits new questions' do
    subscribe

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from('questions_channel')
  end
end
