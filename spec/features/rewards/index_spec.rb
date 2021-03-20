require 'rails_helper'

feature 'User can inspect the list of earned rewards for his best answers', %q(
  In order to assess the quality of provided answers and also get pleasure
  As a user
  I'd like to be able to inspect the list of rewards for answers which were chosen as the best
) do
  given(:user) { create :user, rewards: create_list(:reward, 2) }
  given!(:random_questions) { create_list(:question_with_reward, 2) }

  scenario 'User sees the list of headers of all previously asked questions', js: true do
    log_in user
    visit rewards_path

    user.rewards.each do |reward|
      expect(page).to have_content(reward.question.title)
      expect(page).to have_content(reward.name)
      expect(page).to have_selector("img[alt=\"#{reward.image.filename}\"]")
    end

    random_questions.each do |question|
      expect(page).not_to have_content(question.title)
    end
  end
end
