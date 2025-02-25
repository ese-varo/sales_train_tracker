class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protect_from_forgery with: :exception

  before_action :authenticate_user!

  helper_method :current_user, :user_signed_in?

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    session.delete(:user_id)
    nil
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user!
    unless user_sigend_in?
      redirect_to login_path, alert: "Necesitas iniciar sesion para acceder a esta pagina."
    end
  end

  def authorize_owner!
    unless current_user&.owner?
      redirect_to root_path, alert: "No tienes permisos para acceder a esta pagina."
    end
  end

  def authorize_manager!
    unless current_user&.manager? || current_user&.owner?
      redirect_to root_path, alert: "No tienes permisos para acceder a esta pagina."
    end
  end

  def authorize_location_access!
    location_id = params[:location_id] || params[:id]
    location = Location.find_by(id: location_id)

    unless location && (current_user.owner? ||
                        current_user.manager? ||
                        (current_user.location_id == location_id))
      redirect_to root_path, alert: "No tienes permisos para acceder a esta sucursal."
    end
  end
end
