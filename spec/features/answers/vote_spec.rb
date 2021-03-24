require 'rails_helper'

feature 'An authenticated user can vote for and against an answer', %q(
  In order to support the best answers
  As an authenticated user
  I'd like to be able to vote for and against answers
) do
  given!(:answer) { create(:answer) }

  describe 'Authenticated user', js: true do
    given(:user) { create :user }

    background do
      log_in user
      visit question_path(answer.question)
    end

    scenario 'Votes against an answer' do
      within "#answer-#{answer.id}-rating" do
        expect(page).to have_content('0')

        click_on 'Против'

        expect(page).to have_content('-1')
      end
    end

    describe 'Votes for an answer' do
      background { within("#answer-#{answer.id}-rating") { click_on 'За' } }

      scenario 'just votes for an answer' do
        within("#answer-#{answer.id}-rating") { expect(page).to have_content('1') }
      end

      describe 'then' do
        scenario 'cannot vote again' do
          within("#answer-#{answer.id}-rating") { expect(page).not_to have_link('За') }
        end

        scenario 'cancels the decision' do
          within("#answer-#{answer.id}-rating") do
            click_on 'Отменить'
            expect(page).to have_content('0')
          end
        end

        describe 'then' do
          scenario 'votes for the answer again' do
            within "#answer-#{answer.id}-rating" do
              click_on 'Отменить'

              click_on 'За'
              expect(page).to have_content('1')
            end
          end
        end
      end
    end
  end

  scenario 'Unauthenticated user cannot vote' do
    visit(question_path(answer.question))

    expect(page).not_to have_link('За')
    expect(page).not_to have_link('Против')
  end
end
