# Contrôleur pour l'authentification des administrateurs
class Admin::SessionsController < ApplicationController
  # Formulaire de connexion
  def new
    redirect_to admin_root_path if logged_in?
  end
  
  # Traitement de la connexion
  def create
    admin = Admin.find_by(email: params[:email])
    
    if admin&.authenticate(params[:password])
      session[:admin_id] = admin.id
      flash[:notice] = "Connexion réussie ! Bienvenue #{admin.email}."
      redirect_to admin_root_path
    else
      flash.now[:alert] = "Email ou mot de passe incorrect."
      render :new, status: :unprocessable_entity
    end
  end
  
  # Déconnexion
  def destroy
    session.delete(:admin_id)
    @current_admin = nil
    flash[:notice] = "Vous avez été déconnecté."
    redirect_to root_path
  end
end
