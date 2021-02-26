require 'rails_helper'

feature 'Authenticated user can write an answer on the question page (without redirecting)', %q(
  In order to help other users
  As an authenticated user
  I'd like to be able to write an answer and see the question while doing this
) do
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { log_in(user) }

    background { visit question_path(question) }

    scenario 'writes an answer' do
      fill_in 'Новый ответ:', with: 'answer body'
      click_on 'Ответить'

      expect(page).to have_content 'Ответ был успешно создан!'
      expect(page).to have_content 'answer body'
    end

    scenario 'writes an answer with errors' do
      click_on 'Ответить'

      expect(page).to have_content 'Текст ответа не может быть пустым'
    end
  end

  scenario 'Unauthenticated user tries to write an answer' do
    visit question_path(question)

    fill_in 'Новый ответ:', with: 'answer body'
    click_on 'Ответить'

    expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться.'
  end
end
