require 'rails_helper'

feature 'User receives new answer notifications', %q(
  In order to get the needed information as soon as possible
  As a registered user
  I'd like to be able to receive new answer notifications
) do
  given!(:author) { create :author }
  given!(:question) { create :question, author: author }
  given(:random_user) { create :user }
  given(:subscriber) { create :user }

  scenario 'author receives new answer notification', js: true do
    leave_an_answer author: random_user, body: 'new answer', question: question

    open_email author.email
    expect(current_email).to have_content('new answer')
    expect(current_email).to have_link(question.title)
  end

  scenario 'subscribed user receives new answer notification', js: true do
    Capybara.using_session('subscriber') do
      log_in subscriber
      visit question_path(question)
      click_on 'Подписаться'
      expect(page).to have_content('Вы успешно подписаны')
      expect(page).not_to have_button('Подписаться')
    end

    Capybara.using_session('answer author') do
      leave_an_answer author: random_user, body: 'new answer', question: question
    end

    open_email subscriber.email
    expect(current_email).to have_content('new answer')
    expect(current_email).to have_link(question.title)
  end

  let(:another_question) { create :question }

  scenario 'user subscribes to multiple questions', js: true do
    Capybara.using_session('subscriber') do
      log_in subscriber
      visit question_path(question)
      click_on 'Подписаться'

      visit question_path(another_question)
      click_on 'Подписаться'
    end

    Capybara.using_session('answer author 1') do
      leave_an_answer author: random_user, body: 'new answer 1', question: question
    end

    open_email subscriber.email
    expect(current_email).to have_content('new answer 1')
    expect(current_email).to have_link(question.title)

    Capybara.using_session('answer author 2') do
      leave_an_answer author: random_user, body: 'new answer 2', question: another_question
    end

    open_email subscriber.email
    expect(current_email).to have_content('new answer 2')
    expect(current_email).to have_link(another_question.title)
  end

  let(:subscribing) { create :subscribing, subscription: question }
  let(:subscribed_user) { subscribing.subscriber }

  scenario 'subscribed user do not see a subscribe button' do
    log_in subscribed_user
    visit question_path(question)
    expect(page).not_to have_button('Подписаться')
  end

  scenario 'a guest cannot subscribe to a question updates' do
    visit question_path(question)
    expect(page).not_to have_button('Подписаться')
  end
end
