class RewardsController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  expose! :rewards, -> { current_user.rewards }

  authorize_resource :exposed_rewards, parent: false, class: 'Reward'
end
