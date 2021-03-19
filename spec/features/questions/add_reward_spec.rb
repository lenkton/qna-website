require 'rails_helper'

feature 'User can add a best answer reward to a question', %q(
  To encourage users participate in the discussion
  As a question's author
  I'd like to be able to add a best answer reward to the question
) do
  given(:author) { create :author }

  background do
    log_in author
    visit new_question_path

    fill_in 'Заголовок', with: 'Title'
    fill_in 'Содержание', with: 'text text text'
  end

  scenario 'User adds a best answer reward when asks a question', js: true do
    within '.reward-field' do
      fill_in 'Название', with: 'super answer'
      attach_file 'Изображение', "#{Rails.root}/public/apple-touch-icon.png"
    end

    click_on 'Задать вопрос'

    expect(page).to have_content('Вопрос был успешно создан!')
  end

  scenario 'User adds an incorrect best answer reward', js: true do
    within '.reward-field' do
      fill_in 'Название', with: 'super answer'
    end

    click_on 'Задать вопрос'

    expect(page).to have_content('Reward image не может быть пустым')
  end
end
