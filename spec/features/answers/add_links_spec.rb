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

  background do
    log_in author
    visit question_path(question)

    fill_in 'Новый ответ', with: 'text text text'
  end

  describe 'User adds link when asks an answer', js: true do
    background do
      fill_in 'Название ссылки', with: 'My gist'
      fill_in 'Адрес', with: gist_url

      click_on 'Добавить ссылку'

      within '.nested-fields:nth-of-type(2)' do
        fill_in 'Название ссылки', with: 'GH'
        fill_in 'Адрес', with: random_url
      end

      click_on 'Ответить'
    end

    scenario 'adds several links' do
      within '#answers' do
        expect(page).to have_link('My gist', href: gist_url)
        expect(page).to have_link('GH', href: random_url)
      end
    end

    scenario 'one of the links is a gist' do
      expect(page).to have_content 'nanna'
    end
  end

  scenario 'User adds a link with incorrect URL', js: true do
    fill_in 'Название ссылки', with: 'My gist'
    fill_in 'Адрес', with: 'not_a_url'

    click_on 'Ответить'

    within '#answers' do
      expect(page).not_to have_link('My gist')
      expect(page).not_to have_content('text text text')
    end
  end
end
