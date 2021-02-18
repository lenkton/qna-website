require 'rails_helper'

feature 'User can create question', %q(
  In order to get answer from a community
  As a user
  I'd like to be able to ask the question
) do
  background do
    visit questions_path
    click_on 'Задать вопрос'
  end

  scenario 'User asks a question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_on 'Задать вопрос'

    expect(page).to have_content 'Вопрос был успешно создан!'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text text'
  end

  scenario 'User asks a question with errors' do
    click_on 'Задать вопрос'

    expect(page).to have_content 'Заголовок вопроса не может быть пустым'
  end
end
