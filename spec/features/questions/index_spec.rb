require 'rails_helper'

feature 'User can inspect the list of all questions', %q(
  In order to find a solution to my problem
  As a user
  I'd like to be able to inspect the list of questions asked before
) do
  scenario 'User sees the list of headers of all previously asked questions' do
    question = create(:question)

    visit(questions_path)

    expect(page).to have_content(question.title)
  end
end
