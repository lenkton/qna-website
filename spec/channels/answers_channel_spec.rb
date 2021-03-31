require 'rails_helper'

RSpec.describe AnswersChannel, type: :channel do
  let!(:question) { create :question }

  it 'successfully subscribes and transmits new answers to a specific question' do
    subscribe(question_id: question.id)

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from(AnswersChannel.broadcasting_for(question))
  end

  it 'rejects when the question_id is missing' do
    subscribe

    expect(subscription).to be_rejected
  end
end
