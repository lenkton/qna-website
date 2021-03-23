require 'rails_helper'

feature 'An authenticated user can vote for and against a question', %q(
  In order to support questions of interest
  As an authenticated user
  I'd like to be able to vote for and against questions
) do
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    given(:user) { create :user }

    background do
      log_in user
      visit question_path(question)
    end

    scenario 'Votes against a question' do
      within '#question-rating' do
        expect(page).to have_content('0')

        click_on 'Против'

        expect(page).to have_content('-1')
      end
    end

    describe 'Votes for a question' do
      background { within('#question-rating') { click_on 'За' } }

      scenario 'just votes for a question' do
        within('#question-rating') { expect(page).to have_content('1') }
      end

      describe 'then' do
        scenario 'cannot vote again' do
          within('#question-rating') { expect(page).not_to have_link('За') }
        end
      end
    end
  end

  scenario 'Unauthenticated user cannot vote' do
    visit(question_path(question))

    expect(page).not_to have_link('За')
    expect(page).not_to have_link('Против')
  end
end
