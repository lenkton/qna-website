class NotificationsMailer < ApplicationMailer
  def notification(answer)
    @answer = answer
    mail to: answer.question.author.email
  end
end
