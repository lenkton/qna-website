require 'rails_helper'

feature 'The author of a question can choose the best answer to it', %q(
  In order help other users with finding the solution to their similar problems
  As an author of a question
  I'd like to be able to mark an as the best
) do
  given(:author) { create(:author) }
  given(:random_user) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answers) { create_list(:answer, ANSWERS_DEFAULT_LIST_SIZE, question: question) }
  given(:answer) { answers[3] }
  given(:other_answers) { answers - [answer] }

  describe 'The author', js: true do
    before do
      log_in author
      visit question_path(question)

      within "#answer-#{answer.id}" do
        click_on 'Отметить как лучший'
      end
    end

    scenario 'mark an answer as the best' do
      within '#best-answer' do
        expect(page).to have_content(answer.body)
        other_answers.each { |other_answer| expect(page).not_to have_content(other_answer.body) }
      end

      expect(page.all(:css, '.answer').first).to have_content answer.body
    end

    given(:another_answer) { other_answers[3] }

    scenario 'mark another answer as the best' do
      within "#answer-#{another_answer.id}" do
        click_on 'Отметить как лучший'
      end

      within '#best-answer' do
        expect(page).to have_content(another_answer.body)
        (answers - [another_answer]).each { |other_answer| expect(page).not_to have_content(other_answer.body) }
      end
    end
  end

  scenario 'Random user cannot mark an answer as the best', js: true do
    log_in random_user
    visit question_path(question)

    expect(page).not_to have_link('Отметить как лучший')
  end

  scenario 'Unauthenticated user cannot mark an answer as the best', js: true do
    visit question_path(question)
    expect(page).not_to have_link('Отметить как лучший')
  end
end
