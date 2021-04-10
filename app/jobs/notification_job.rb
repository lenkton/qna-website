class NotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NotificationService.new.notify_author(answer)
  end
end
