require 'rails_helper'

feature 'An authenticated user can vote for and against an answer', %q(
  In order to support the best answers
  As an authenticated user
  I'd like to be able to vote for and against answers
) do
  given(:user) { create :user }
  given(:answer) { create :answer }
  given(:own_answer) { create :answer, author: user }

  describe 'Authenticated user', js: true do
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
          within("#answer-#{answer.id}-rating") { expect(page).not_to have_button('За') }
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

  scenario 'User cannot rate his/her answer' do
    log_in user
    visit(question_path(own_answer.question))

    within "#answer-#{own_answer.id}-rating" do
      expect(page).not_to have_button('За')
      expect(page).not_to have_button('Против')
    end
  end

  scenario 'Unauthenticated user cannot vote' do
    visit(question_path(answer.question))

    expect(page).not_to have_button('За')
    expect(page).not_to have_button('Против')
  end
end
