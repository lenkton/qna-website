require 'rails_helper'

feature 'User can add links to an answer', %q(
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
) do
  given(:author) { create :author }
  given(:gist_url) { 'https://gist.github.com/lenkton/99b9323cc3f01e1d4931486bd65195c4' }
  given(:random_url) { 'https://github.com' }
  given(:question) { create :question }

  scenario 'User adds link when asks an answer', js: true do
    log_in author
    visit question_path(question)

    fill_in 'Новый ответ', with: 'text text text'

    fill_in 'Название ссылки', with: 'My gist'
    fill_in 'Адрес', with: gist_url

    click_on 'Ответить'

    within('#answers') { expect(page).to have_link('My gist', href: gist_url) }
  end
end
