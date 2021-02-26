require 'rails_helper'

feature 'User can sign out', %q(
  In order to end the session
  As an authenticated user
  I'd like to be able to sign out
) do
  given(:user) { create(:user) }

  scenario 'An authenticated user signs in and then signs out' do
    log_in(user)

    click_on 'Выйти'

    expect(page).to have_content('Выход из системы выполнен.')
  end
end
