class SubscribingsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  expose! :subscribing

  authorize_resource :exposed_subscribing, parent: false, class: 'Subscribing'

  def create
    subscribing.subscriber = current_user
    subscribing.subscription_id = params[:question_id]

    subscribing.save
    respond_to do |format|
      format.json { render json: subscribing, root: 'subscribing' }
    end
  end

  def destroy
    subscribing.destroy
  end
end
