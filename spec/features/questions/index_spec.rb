require 'rails_helper'

QUESTIONS_LIST_SIZE = 5

feature 'User can inspect the list of all questions', %q(
  In order to find a solution to my problem
  As a user
  I'd like to be able to inspect the list of questions asked before
) do
  let!(:questions) { create_list(:question, QUESTIONS_LIST_SIZE) }

  scenario 'User sees the list of headers of all previously asked questions' do
    visit(questions_path)

    questions.each { |question| expect(page).to have_content(question.title) }
  end
end
