require 'rails_helper'

feature 'An authorized user can delete his own questions', %q(
  In order to shift other users' attention from the question
  As an authorized user
  I'd like to be able delete my question
) do
  given(:user) { create(:user) }
  given(:unauthorized_user) { create(:user) }
  given!(:question) { user.questions.create!(attributes_for(:question)) }

  scenario 'An authorized user deletes his question' do
    log_in(user)

    visit question_path(question)
    click_on('Удалить вопрос')

    expect(page).to have_content('Вопрос был успешно удалён!')
  end

  scenario 'An unauthorized user tries to delete a question' do
    log_in(unauthorized_user)

    visit question_path(question)

    click_on('Удалить вопрос')

    expect(page).to have_content('У вас нет достаточных прав для совершения этого действия.')
  end
end
