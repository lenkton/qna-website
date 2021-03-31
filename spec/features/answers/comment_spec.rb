require 'rails_helper'

feature 'Authenticated user can comment an answer', %q(
  In order to ask an answer's author for feedback
  As an authenticated user
  I'd like to be able to comment the answer
) do
  given(:user) { create :user }
  given(:question) { create :question }
  given!(:answer) { create :answer, question: question }

  describe 'Authenticated user', js: true do
    background do
      log_in user
      visit question_path(question)
    end

    scenario 'Creates a comment' do
      within "#answer-#{answer.id}" do
        fill_in 'Комментарий', with: 'Comment text'
        click_on 'Комментировать'

        expect(page).to have_content('Comment text')
        expect(find_field('Комментарий').value).to eq('')
      end
    end

    scenario 'Create no comment with invalid params' do
      within "#answer-#{answer.id}" do
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

      within "#answer-#{answer.id}" do
        fill_in 'Комментарий', with: 'Comment text'
        click_on 'Комментировать'
      end
    end

    Capybara.using_session('guest') do
      within("#answer-#{answer.id}") { expect(page).to have_content('Comment text') }
    end
  end

  scenario 'User comments newly created answer (without reloading the page)', js: true do
    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('author') do
      log_in user
      visit question_path(question)

      fill_in 'Новый ответ', with: 'New answer'
      click_on 'Ответить'

      expect(page).to have_content('New answer') # needed for racing condition connected purposes

      within "#answer-#{Answer.last.id}" do
        fill_in 'Комментарий', with: 'Comment text'
        click_on 'Комментировать'
      end
    end

    Capybara.using_session('guest') do
      within("#answer-#{Answer.last.id}") do
        expect(page).to have_content('New answer')
        expect(page).to have_content('Comment text')
      end
    end
  end

  scenario 'Unauthenticated user cannot comment' do
    visit question_path(question)

    expect(page).not_to have_field('Комментарий')
    expect(page).not_to have_button('Комментировать')
  end
end
