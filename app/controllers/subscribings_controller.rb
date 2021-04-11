class SubscribingsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  expose! :subscribing

  authorize_resource :exposed_subscribing, parent: false, class: 'Subscribing'

  def create
    subscribing.subscriber = current_user
    subscribing.subscription_id = params[:question_id]

    subscribing.save
  end
end
