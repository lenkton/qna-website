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
        expect(page).not_to have_selector('.field input')
      end
    end

    describe 'interacts with files' do
      background do
        within '#question-edit-form' do
          attach_file 'Прикреплённые файлы', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Сохранить'
        end
      end

      describe 'adds files to the question' do

        scenario 'with no previously added files' do
          within '#question' do
            expect(page).not_to have_button('Прикреплённые файлы')
            expect(page).to have_link 'rails_helper.rb'
            expect(page).to have_link 'spec_helper.rb'
          end
        end

        scenario 'with previously added files' do
          click_on('Редактировать вопрос')

          within '#question-edit-form' do
            attach_file 'Прикреплённые файлы', ["#{Rails.root}/Gemfile", "#{Rails.root}/Gemfile.lock"]
            click_on 'Сохранить'
          end

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
          expect(page).to have_link 'Gemfile'
          expect(page).to have_link 'Gemfile.lock'
        end
      end

      scenario 'deletes a file' do
        expect(page).to have_link 'rails_helper.rb' # to prevent race conditions
        question.reload
        within("#file-#{question.files.first.id}") { accept_alert { click_on('Удалить') } }

        expect(page).not_to have_link(question.files.first.filename.to_s)
      end
    end

    describe 'add links' do
      given(:gist_url) { 'https://gist.github.com/lenkton/99b9323cc3f01e1d4931486bd65195c4' }
      given(:random_url) { 'https://github.com' }

      describe 'Correct links', js: true do
        background do
          within '#question-edit-form' do
            click_on 'Добавить ссылку'

            fill_in 'Название ссылки', with: 'My gist'
            fill_in 'Адрес', with: gist_url

            click_on 'Добавить ссылку'

            within '.nested-fields:nth-of-type(2)' do
              fill_in 'Название ссылки', with: 'GH'
              fill_in 'Адрес', with: random_url
            end

            click_on 'Сохранить'
          end
        end

        scenario 'adds several links' do
          within '#question' do
            expect(page).to have_link('My gist', href: gist_url)
            expect(page).to have_link('GH', href: random_url)
          end
        end

        scenario 'one of the links is a gist' do
          within('#question') { expect(page).to have_content 'nanna' }
        end
      end

      scenario 'User adds a link with incorrect URL', js: true do
        within '#question-edit-form' do
          click_on 'Добавить ссылку'

          fill_in 'Название ссылки', with: 'My gist'
          fill_in 'Адрес', with: 'not_a_url'

          click_on 'Сохранить'
        end

        expect(page).not_to have_link('My gist')
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
          expect(page).not_to have_selector('.field input')
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
