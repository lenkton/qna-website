class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  rescue_from ActiveRecord::RecordNotFound, with: :rescue_record_not_found

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id)
  end

  def current_user
    current_resource_owner
  end

  def rescue_record_not_found
    head 404
  end
end
