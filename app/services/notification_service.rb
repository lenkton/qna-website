class NotificationService
  def notify_author(answer)
    NotificationsMailer.notification(answer).deliver_later
  end
end
