require 'rails_helper'

feature 'Authenticated user can write an answer on the question page (without redirecting)', %q(
  In order to help other users
  As an authenticated user
  I'd like to be able to write an answer and see the question while doing this
) do
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }

    background { log_in(user) }

    background { visit question_path(question) }

    describe 'writes a valid answer' do
      background { fill_in 'Новый ответ:', with: 'answer body' }

      scenario 'writes an answer' do
        click_on 'Ответить'

        within('#answers') { expect(page).to have_content 'answer body' }
      end

      scenario 'writes an answer with attached files' do
        attach_file 'Прикреплённые файлы', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Ответить'

        within('#answers') do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    scenario 'writes an answer with errors' do
      click_on 'Ответить'

      expect(page).to have_content 'Текст ответа не может быть пустым'
    end
  end

  scenario 'Unauthenticated user tries to write an answer', js: true do
    visit question_path(question)

    expect(page).not_to have_field 'Новый ответ:'
    expect(page).not_to have_field 'Ответить'
  end
end
