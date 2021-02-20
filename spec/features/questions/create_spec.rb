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

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Задать вопрос'

      expect(page).to have_content 'Вопрос был успешно создан!'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors' do
      click_on 'Задать вопрос'

      expect(page).to have_content 'Заголовок вопроса не может быть пустым'
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Задать вопрос'

    expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться.'
  end
end
