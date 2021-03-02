require 'rails_helper'

feature 'User can edit his/her question', %q(
  In order to correct mistakes
  As an author of a question
  I'd like ot be able to edit my question
) do
  given(:author) { create(:author) }
  given(:random_user) { create(:user) }
  given(:question) { create(:question, author: author, body: 'old body', title: 'old title') }

  describe 'The author', js: true do
    background do
      log_in(author)
      visit question_path(question)
      click_on('Редактировать вопрос')
      expect(current_path).to eq question_path(question) # to ensure the abscence of redirection
    end

    scenario 'edits his/her question' do
      fill_in 'Заголовок', with: 'edited title'
      fill_in 'Содержание', with: 'edited body'
      click_on 'Сохранить'

      within '#question' do
        expect(page).to have_content('edited title')
        expect(page).to have_content('edited body')
        expect(page).not_to have_content('old title')
        expect(page).not_to have_content('old body')
        expect(page).not_to have_selector('textarea')
        expect(page).not_to have_selector('input')
      end
    end

    describe 'with errors' do
      background do
        fill_in 'Заголовок', with: ''
        fill_in 'Содержание', with: ''
        click_on 'Сохранить'
      end

      scenario 'edits his/her question with errors' do
        within '#question-edit-form' do
          expect(page).to have_content('Текст вопроса не может быть пустым!')
          expect(find_field('Заголовок').value).to eq ''
          expect(find_field('Содержание').value).to eq ''
        end
      end

      # to test a bug, where the error was displayed
      # after the correct request was send
      scenario 'edits the question firstrly with mistakes, and then correctly' do
        fill_in 'Заголовок', with: 'edited title'
        fill_in 'Содержание', with: 'edited body'
        click_on 'Сохранить'

        within '#question' do
          expect(page).to have_content('edited title')
          expect(page).to have_content('edited body')
          expect(page).not_to have_content('old title')
          expect(page).not_to have_content('old body')
          expect(page).not_to have_selector('textarea')
          expect(page).not_to have_selector('input')
        end

        click_on 'Редактировать вопрос'

        within '#question-edit-form' do
          expect(find_field('Заголовок').value).to eq 'edited title'
          expect(find_field('Содержание').value).to eq 'edited body'
          expect(page).not_to have_content('Текст вопроса не может быть пустым!')
        end
      end
    end
  end

  scenario 'Random user cannot edit a question' do
    log_in(random_user)
    visit question_path(question)

    expect(page).not_to have_link('Редактировать вопрос')
  end

  scenario 'Unauthenticated user cannot edit a question' do
    visit question_path(question)

    expect(page).not_to have_link('Редактировать вопрос')
  end
end
