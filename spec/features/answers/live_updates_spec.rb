require 'rails_helper'

feature 'Users get live updates of the content of a question page', %q(
  In order not to miss any new information while interacting with the page
  As a user
  I'd like to be able to see live updates of the content of the question's page
) do
  given!(:question) { create(:question) }
  given(:user) { create(:user) }
  given(:random_user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/lenkton/99b9323cc3f01e1d4931486bd65195c4' }
  given(:random_url) { 'https://github.com' }

  scenario "a new question appears on another user's page", js: true do
    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('random user') do
      log_in random_user
      visit question_path(question)
    end

    Capybara.using_session('author') do
      log_in user
      visit question_path(question)

      attach_file 'Прикреплённые файлы', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      fill_in 'Новый ответ:', with: 'text text text'
      fill_in 'Название ссылки', with: 'My gist'
      fill_in 'Адрес', with: gist_url

      click_on 'Добавить ссылку'

      within '.nested-fields:nth-of-type(2)' do
        fill_in 'Название ссылки', with: 'GH'
        fill_in 'Адрес', with: random_url
      end

      click_on 'Ответить'

      within '#answers' do
        expect(page).not_to have_button('За')
        expect(page).not_to have_button('Против')
      end
    end

    Capybara.using_session('guest') do
      within '#answers' do
        expect(page).to have_content('text text text')
        expect(page).not_to have_button('За')
        expect(page).not_to have_button('Против')
      end
    end

    Capybara.using_session('random user') do
      within '#answers' do
        expect(page).to have_button('За')
        expect(page).to have_button('Против')
      end
    end
  end
end
