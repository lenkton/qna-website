class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource parent: false, class: 'User'

  def me
    render json: current_resource_owner
  end
end
