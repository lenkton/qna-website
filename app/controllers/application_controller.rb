class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :unauthorized }
      format.js { head :unauthorized }
      format.html { redirect_to :root, alert: exception.message }
    end
  end

  check_authorization unless: :devise_controller?
end
