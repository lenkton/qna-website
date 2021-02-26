require 'rails_helper'

feature 'User can sign up', %q(
  In order to get an opportunity to ask questions and write answers
  As an unregistered user
  I'd like to be able to create an account
) do
  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'An unregistered user tries to sign up with correct data' do
    fill_in 'Email', with: attributes_for(:user)[:email]
    fill_in 'Password', with: attributes_for(:user)[:password]
    fill_in 'Password confirmation', with: attributes_for(:user)[:password_confirmation]
    click_on 'Sign up'

    expect(page).to have_content('Добро пожаловать! Вы успешно зарегистрировались.')
  end

  scenario 'An unregistered user tries to sign up with incorrect data' do
    click_on 'Sign up'
    expect(page).to have_content('Email не может быть пустым')
  end

  scenario 'A registered user tries to sign up again' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content('Email уже существует')
  end
end
