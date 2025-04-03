class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken  # Enables token-based authentication
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:usertype])
  end

  def authorize_organizer!
    unless current_user&.organizer?
      render json: { error: "Access denied. Organizers only." }, status: :forbidden
    end
  end

  def authorize_customer!
    unless current_user&.customer?
      render json: { error: "Access denied. Customers only." }, status: :forbidden
    end
  end
end

