require 'rails_helper'

feature 'Authenticated user can create question', %q(
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
) do
  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      log_in(user)
      visit questions_path
      click_on 'Задать вопрос'
    end

    describe 'asks a valid question' do
      background do
        fill_in 'Заголовок', with: 'Test question'
        fill_in 'Содержание', with: 'text text text'
      end

      scenario 'asks a plain question' do
        click_on 'Задать вопрос'

        expect(page).to have_content 'Вопрос был успешно создан!'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      scenario 'asks a question with files' do
        attach_file 'Прикреплённые файлы', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Задать вопрос'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'asks a question with errors' do
      click_on 'Задать вопрос'

      expect(page).to have_content 'Заголовок вопроса не может быть пустым'
    end

    describe 'multiple sessions', js: true do
      scenario "a new question appears on another user's page" do
        Capybara.using_session('guest') do
          visit questions_path
        end

        Capybara.using_session('author') do
          log_in user
          visit questions_path
          click_on 'Задать вопрос'

          fill_in 'Заголовок', with: 'Test question'
          fill_in 'Содержание', with: 'text text text'
          click_on 'Задать вопрос'
        end

        Capybara.using_session('guest') do
          expect(page).to have_link('Test question', href: question_path(Question.last))
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Задать вопрос'

    expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться.'
  end
end
