require 'rails_helper'

feature 'An authenticated user can vote for and against a question', %q(
  In order to support questions of interest
  As an authenticated user
  I'd like to be able to vote for and against questions
) do
  given(:user) { create :user }
  given!(:question) { create(:question) }
  given(:own_question) { create :question, author: user }

  describe 'Authenticated user', js: true do
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
          within('#question-rating') { expect(page).not_to have_button('За') }
        end

        scenario 'cancels the decision' do
          within('#question-rating') do
            click_on 'Отменить'
            expect(page).to have_content('0')
          end
        end

        describe 'then' do
          scenario 'votes for the question again' do
            within '#question-rating' do
              click_on 'Отменить'

              click_on 'За'
              expect(page).to have_content('1')
            end
          end
        end
      end
    end
  end

  scenario 'User cannot rate his/her question' do
    log_in user
    visit(question_path(own_question))

    expect(page).not_to have_button('За')
    expect(page).not_to have_button('Против')
  end

  scenario 'Unauthenticated user cannot vote' do
    visit(question_path(question))

    expect(page).not_to have_button('За')
    expect(page).not_to have_button('Против')
  end
end
