require 'rails_helper'

feature 'Authenticated user receives daily digest', %q(
  In order to be notified of the latest questions
  As a registered user
  I'd like to be able to receive daily digest with the latest questions
) do
  given!(:questions) { create_list :question, 5 }
  given!(:old_questions) { create_list :question, 4, created_at: 1.day.before }
  given!(:user) { create :user }

  background do
    DailyDigestMailer.digest(user).deliver_now
    open_email user.email
  end

  scenario 'registered user receives its daily digest' do
    questions.each { |question| expect(current_email).to have_content(question.title) }
    old_questions.each { |question| expect(current_email).not_to have_content(question.title) }
  end
end
