require 'rails_helper'

feature 'An authorized user can delete his/her own questions', %q(
  In order to shift other users' attention from the question
  As an authorized user
  I'd like to be able delete my question
) do
  given(:author) { create(:author) }
  given(:random_user) { create(:user) }
  given!(:question) { create(:question, author: author) }

  scenario 'An author user deletes his/her question' do
    log_in(author)

    visit question_path(question)
    click_on('Удалить вопрос')

    expect(page).to have_content('Вопрос был успешно удалён!')
  end

  scenario 'A random user tries to delete a question' do
    log_in(random_user)

    visit question_path(question)

    click_on('Удалить вопрос')

    expect(page).to have_content('У вас нет достаточных прав для совершения этого действия.')
  end

  scenario 'An unauthenticated user tries to delete a question' do
    visit question_path(question)

    click_on('Удалить вопрос')

    expect(page).to have_content('У вас нет достаточных прав для совершения этого действия.')
  end
end
