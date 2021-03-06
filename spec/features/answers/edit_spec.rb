require 'rails_helper'

feature 'User can edit his/her answer', %q(
  In order to correct mistakes
  As an author of an answer
  I'd like ot be able to edit my answer
) do
  given(:author) { create(:author) }
  given(:random_user) { create(:user) }
  given(:answer) { create(:answer, author: author, body: 'old body') }

  describe 'The author', js: true do
    background do
      log_in(author)
      visit question_path(answer.question)
      within("#answer-#{answer.id}") { click_on('Редактировать') }
      expect(current_path).to eq question_path(answer.question) # to ensure the abscence of redirection
    end

    scenario 'closes the edit mode' do
      click_on 'Отменить'
      within('#answers') do
        expect(page).not_to have_selector('textarea')
        expect(page).to have_content(answer.body)
      end
    end

    scenario 'edits his/her answer' do
      within '#answers' do
        fill_in 'Содержание', with: 'edited body'
        click_on 'Сохранить'
      end

      within "#answer-#{answer.id}" do
        expect(page).to have_content('edited body')
        expect(page).not_to have_content('old body')
        expect(page).not_to have_selector('textarea')
      end
    end

    describe 'adds files to the answer' do
      background do
        within "#answer-#{answer.id}-edit-form" do
          attach_file 'Прикреплённые файлы', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Сохранить'
        end
      end

      scenario 'with no previously added files' do
        within "#answer-#{answer.id}" do
          expect(page).not_to have_button('Прикреплённые файлы')
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'with previously added files' do
        expect(page).to have_link 'rails_helper.rb' # to prevent race conditions

        within("#answer-#{answer.id}") { click_on('Редактировать') }

        within "#answer-#{answer.id}-edit-form" do
          attach_file 'Прикреплённые файлы', ["#{Rails.root}/Gemfile", "#{Rails.root}/Gemfile.lock"]
          click_on 'Сохранить'
        end

        within "#answer-#{answer.id}" do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
          expect(page).to have_link 'Gemfile'
          expect(page).to have_link 'Gemfile.lock'
        end
      end

      scenario 'then deletes a file' do
        expect(page).to have_link 'rails_helper.rb' # to prevent race conditions
        answer.reload

        within("#file-#{answer.files.first.id}") { accept_alert { click_on('Удалить') } }

        expect(page).not_to have_link(answer.files.first.filename.to_s)
      end
    end

    describe 'add links' do
      given(:gist_url) { 'https://gist.github.com/lenkton/99b9323cc3f01e1d4931486bd65195c4' }
      given(:random_url) { 'https://github.com' }

      describe 'Correct links', js: true do
        background do
          within "#answer-#{answer.id}-edit-form" do
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
          within "#answer-#{answer.id}" do
            expect(page).to have_link('My gist', href: gist_url)
            expect(page).to have_link('GH', href: random_url)
          end
        end

        scenario 'one of the links is a gist' do
          within("#answer-#{answer.id}") { expect(page).to have_content 'nanna' }
        end
      end

      scenario 'User adds a link with incorrect URL', js: true do
        within "#answer-#{answer.id}-edit-form" do
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
        within '#answers' do
          fill_in 'Содержание', with: ''
          click_on 'Сохранить'
        end
      end

      scenario 'edits his/her answer with errors' do
        within "#answer-#{answer.id}-edit-form" do
          expect(page).to have_content('Текст ответа не может быть пустым!')
          expect(find_field('Содержание').value).to eq ''
        end
      end

      # to test a bug, where the error was displayed
      # after the correct request was send
      scenario 'edits the answer firstrly with mistakes, and then correctly' do
        within "#answer-#{answer.id}-edit-form" do
          expect(page).to have_content('Текст ответа не может быть пустым!')
          expect(find_field('Содержание').value).to eq ''
        end

        within '#answers' do
          fill_in 'Содержание', with: 'edited body'
          click_on 'Сохранить'
        end

        within "#answer-#{answer.id}" do
          expect(page).to have_content('edited body')
          expect(page).not_to have_content('old body')
          expect(page).not_to have_selector('textarea')
        end

        within("#answer-#{answer.id}") { click_on 'Редактировать' }

        within "#answer-#{answer.id}-edit-form" do
          expect(find_field('Содержание').value).to eq 'edited body'
          expect(page).not_to have_content('Текст ответа не может быть пустым!')
        end
      end
    end
  end

  scenario 'Random user cannot edit an answer' do
    log_in(random_user)
    visit question_path(answer.question)

    within("#answer-#{answer.id}") { expect(page).not_to have_link('Редактировать') }
  end

  scenario 'Unauthenticated user cannot edit an answer' do
    visit question_path(answer.question)

    within("#answer-#{answer.id}") { expect(page).not_to have_link('Редактировать') }
  end
end
