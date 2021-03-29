require 'rails_helper'

RSpec.describe QuestionChannel, type: :channel do
  let!(:question) { create :question }

  it 'successfully subscribes and transmits new answers to a specific question' do
    subscribe(question_id: question.id)

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("question_#{question.id}_channel")
  end

  it 'rejects when the question_id is missing' do
    subscribe

    expect(subscription).to be_rejected
  end
end
