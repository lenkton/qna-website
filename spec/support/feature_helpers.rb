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

  def leave_an_answer(args)
    clear_enqueued_jobs
    perform_enqueued_jobs do
      log_in args.fetch(:author)
      visit question_path(args.fetch(:question))
      fill_in 'Новый ответ', with: args.fetch(:body)
      click_on 'Ответить'
      within('#answers') { expect(page).to have_content 'new answer' } # for race condition avoiding purposes
    end
  end
end
