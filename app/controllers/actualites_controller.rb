# Contrôleur pour la gestion des actualités (partie publique)
class ActualitesController < ApplicationController
  # Liste de toutes les actualités publiées
  def index
    @actualites = Actualite.publiees
  end
  
  # Détails d'une actualité spécifique
  def show
    @actualite = Actualite.find(params[:id])
    
    # Vérifier si l'article est publié
    unless @actualite.publie?
      flash[:alert] = "Cet article n'est pas encore publié."
      redirect_to actualites_path
    end
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Article non trouvé."
    redirect_to actualites_path
  end
end
