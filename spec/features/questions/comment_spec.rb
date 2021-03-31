require 'rails_helper'

feature 'Authenticated user can comment question', %q(
  In order to ask a question author for feedback
  As an authenticated user
  I'd like to be able to comment the question
) do
  given(:user) { create :user }
  given(:question) { create :question }

  describe 'Authenticated user', js: true do
    background do
      log_in user
      visit question_path(question)
    end

    scenario 'Creates a comment' do
      within '#question' do
        fill_in 'Комментарий', with: 'Comment text'
        click_on 'Комментировать'

        expect(page).to have_content('Comment text')
        expect(find_field('Комментарий').value).to eq('')
      end
    end

    scenario 'Create no comment with invalid params' do
      within '#question' do
        fill_in 'Комментарий', with: ''
        click_on 'Комментировать'

        expect(page).to have_content('Text не может быть пустым')
      end

      expect(page).not_to have_content('Comment text')
    end
  end

  scenario 'Everyone see comment creation without reloading the page', js: true do
    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('author') do
      log_in user
      visit question_path(question)

      fill_in 'Комментарий', with: 'Comment text'
      click_on 'Комментировать'
    end

    Capybara.using_session('guest') do
      within('#question') { expect(page).to have_content('Comment text') }
    end
  end

  scenario 'Unauthenticated user cannot comment' do
    visit question_path(question)

    expect(page).not_to have_field('Комментарий')
    expect(page).not_to have_button('Комментировать')
  end
end
