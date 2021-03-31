require 'rails_helper'

RSpec.describe CommentsChannel, type: :channel do
  let!(:commentable) { create :question }

  it 'successfully subscribes and transmits new comments to a specific commentable' do
    subscribe(commentable_id: commentable.id, commentable_type: commentable.class.to_s)

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from(CommentsChannel.broadcasting_for(commentable))
  end

  it 'rejects when the question_id is missing' do
    subscribe

    expect(subscription).to be_rejected
  end
end
