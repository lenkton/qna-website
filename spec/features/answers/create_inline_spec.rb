require 'rails_helper'

feature 'User can write an answer on the question page (without redirecting)', %q(
  In order to write an appropriate answer
  As a user
  I'd like to be able to see the question while writing the answer
) do
  let!(:question) { create(:question) }
  scenario 'User writes an answer' do
    visit question_path(question)

    fill_in 'Новый ответ:', with: 'answer body'
    click_on 'Ответить'

    expect(page).to have_content 'Ответ был успешно создан!'
    expect(page).to have_content 'answer body'
  end

  scenario 'User writes an answer with errors'
end
