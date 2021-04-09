class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @new_questions = Question.where('created_at > ?', 1.day.before)

    mail to: user.email
  end
end
