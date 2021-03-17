require 'rails_helper'

feature 'User can add links to a question', %q(
  In order to provide additional info to my question
  As a question's author
  I'd like to be able to add links
) do
  given(:author) { create :author }
  given(:gist_url) { 'https://gist.github.com/lenkton/99b9323cc3f01e1d4931486bd65195c4' }
  given(:random_url) { 'https://github.com' }

  scenario 'User adds link when asks a question' do
    log_in author
    visit new_question_path

    fill_in 'Заголовок', with: 'Title'
    fill_in 'Содержание', with: 'text text text'

    fill_in 'Название ссылки', with: 'My gist'
    fill_in 'Адрес', with: gist_url

    click_on 'Задать вопрос'

    expect(page).to have_link('My gist', href: gist_url)
  end
end
