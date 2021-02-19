require 'rails_helper'

feature 'User can sign in', %q(
  in order to be able to ask questions and write answers
  As a registered user
  I'd like to be able to sign in
) do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'User signs in with correct data' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content('Вход в систему выполнен.')
  end

  scenario 'User signs in with incorrect data' do
    fill_in 'Email', with: 'wrong_email@test.com'
    fill_in 'Password', with: 'wrong_password'
    click_on 'Log in'

    expect(page).to have_content('Неверный Email или пароль.')
  end
end
