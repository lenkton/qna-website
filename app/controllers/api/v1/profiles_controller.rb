class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource parent: false, class: 'User'

  def index
    render json: User.where.not(id: doorkeeper_token.resource_owner_id)
  end

  def me
    render json: current_resource_owner
  end
end
