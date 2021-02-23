require 'rails_helper'

feature 'An authorized user can delete his/her own answer', %q(
  In order to shift other users' attention from the answer
  As an authorized user
  I'd like to be able delete my answer
) do
  given(:question_creator) { create(:user) }
  given(:user) { create(:user) }
  given(:unauthorized_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'An authorized user deletes his/her answer' do
    log_in(user)

    visit question_path(question)

    within("li[data-answer-id=\"#{answer.id}\"]") { click_on('Удалить') }

    expect(page).to have_content('Ответ был успешно удалён!')
  end

  scenario 'An unauthorized user tries to delete an answer' do
    log_in(unauthorized_user)

    visit question_path(question)

    within("li[data-answer-id=\"#{answer.id}\"]") { click_on('Удалить') }

    expect(page).to have_content('У вас нет достаточных прав для совершения этого действия.')
  end
end
