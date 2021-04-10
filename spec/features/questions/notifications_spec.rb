require 'rails_helper'

feature 'User receives new answer notifications', %q(
  In order to get the needed information as soon as possible
  As an author of a question
  I'd like to be able to receive new answer notifications
) do
  given!(:author) { create :author }
  given!(:question) { create :question, author: author }
  given(:random_user) { create :user }

  background do
    clear_enqueued_jobs
    perform_enqueued_jobs do
      log_in random_user
      visit question_path(question)
      fill_in 'Новый ответ', with: 'new answer'
      click_on 'Ответить'
      within('#answers') { expect(page).to have_content 'new answer' }
    end
  end

  scenario 'author receives new answer notification', js: true do
    open_email author.email
    expect(current_email).to have_content('new answer')
    expect(current_email).to have_link(question.title)
  end
end
