require 'rails_helper'

describe NotificationService do
  let!(:question) { create :question, author: author }
  let(:author) { create :author }
  let!(:answer) { create :answer, question: question }
  let(:subscribing) { create :subscribing, subscription: question }
  let!(:subscriber) { subscribing.subscriber }
  let(:random_user) { create :user }

  it 'sends new answer notifications to subscribed users' do
    [subscriber, author].each do |user|
      expect(NotificationsMailer).to receive(:notification).with(answer, user).and_call_original
    end
    expect(NotificationsMailer).not_to receive(:notification).with(answer, random_user).and_call_original

    subject.send_notifications(answer)
  end
end
