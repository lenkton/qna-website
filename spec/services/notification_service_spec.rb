require 'rails_helper'

describe NotificationService do
  let!(:question) { create :question, author: author }
  let(:author) { create :author }
  let(:answer) { create :answer }

  it 'sends new answer notification to the author of the question' do
    expect(NotificationsMailer).to receive(:notification).with(answer).and_call_original
    subject.notify_author(answer)
  end
end
