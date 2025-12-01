class ApplicationController < ActionController::Base
  # Méthodes d'aide pour l'authentification admin
  helper_method :current_admin, :logged_in?
  
  private
  
  # Retourne l'admin actuellement connecté
  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id]) if session[:admin_id]
  end
  
  # Vérifie si un admin est connecté
  def logged_in?
    current_admin.present?
  end
  
  # Redirige si non authentifié
  def require_admin
    unless logged_in?
      flash[:alert] = "Vous devez être connecté pour accéder à cette page."
      redirect_to admin_login_path
    end
  end
end
