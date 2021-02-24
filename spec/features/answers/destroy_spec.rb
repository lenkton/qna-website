require 'rails_helper'

feature 'An authorized user can delete his/her own answer', %q(
  In order to shift other users' attention from the answer
  As an authorized user
  I'd like to be able delete my answer
) do
  given(:author) { create(:author) }
  given(:random_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, author: author, question: question) }

  scenario 'An author deletes his/her answer' do
    log_in(author)

    visit question_path(question)

    within("li[data-answer-id=\"#{answer.id}\"]") { click_on('Удалить') }

    expect(page).to have_content('Ответ был успешно удалён!')
  end

  scenario 'A random user tries to delete an answer' do
    log_in(random_user)

    visit question_path(question)

    within("li[data-answer-id=\"#{answer.id}\"]") { click_on('Удалить') }

    expect(page).to have_content('У вас нет достаточных прав для совершения этого действия.')
  end

  scenario 'An unauthenticated user tries to delete an answer' do
    visit question_path(question)

    within("li[data-answer-id=\"#{answer.id}\"]") { click_on('Удалить') }

    expect(page).to have_content('У вас нет достаточных прав для совершения этого действия.')
  end
end
