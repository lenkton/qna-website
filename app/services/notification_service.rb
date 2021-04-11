class NotificationService
  def send_notifications(answer)
    answer.question.subscribers.each do |user|
      NotificationsMailer.notification(answer, user).deliver_later
    end
  end
end
