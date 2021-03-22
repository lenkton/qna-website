require 'rails_helper'

feature 'User can remove links from an answer', %q(
  In order to correct infromation about an answer
  As an answer's author
  I'd like to be able to remove links
) do
  given(:author) { create :author }
  given(:random_user) { create :user }
  given(:answer) { create :answer, author: author }
  given!(:gist_link) { create :link, linkable: answer, name: 'gist', url: 'https://gist.github.com/lenkton/99b9323cc3f01e1d4931486bd65195c4' }
  given!(:random_link) { create :link, linkable: answer, name: 'random', url: 'https://github.com' }

  scenario 'Author removes a link', js: true do
    log_in author
    visit question_path(answer.question)

    within("#link-#{gist_link.id}") { accept_alert { click_on 'Удалить' } }

    expect(page).not_to have_link(gist_link.name)
    expect(page).not_to have_content('nanna')
  end

  scenario 'Random user cannot remove a link' do
    log_in random_user
    visit question_path(answer.question)

    within("#link-#{gist_link.id}") { expect(page).not_to have_link('Удалить') }
  end

  scenario 'Unauthenticated user cannot remove a link' do
    visit question_path(answer.question)

    within("#link-#{gist_link.id}") { expect(page).not_to have_link('Удалить') }
  end
end
