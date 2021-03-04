require 'rails_helper'

feature 'User can inspect the question and its answers', %q(
  In order to find a solution to my problem
  As a user
  I'd like to be able to inspect the question of interest and read the users' answers
) do
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, ANSWERS_DEFAULT_LIST_SIZE, question: question) }

  scenario 'User sees the header, the body and the answers of the question' do
    visit(question_path(question))

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    answers.each { |answer| expect(page).to have_content(answer.body) }
  end
end
