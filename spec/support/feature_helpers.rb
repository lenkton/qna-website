module FeatureHelpers
  def log_in(user)
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def wait_for(timeout = 10)
    Timeout.timeout(timeout) do
      loop do
        condition = yield
        break true if condition
      end
    end
  rescue Timeout::Error
    raise "Condition not true in #{timeout} seconds"
  end
end
