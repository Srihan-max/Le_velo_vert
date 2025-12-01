# Contrôleur pour la gestion des itinéraires (partie publique)
class ItinerairesController < ApplicationController
  # Liste de tous les itinéraires
  def index
    @itineraires = if params[:niveau].present?
      Itineraire.par_niveau(params[:niveau])
    else
      Itineraire.recents
    end
    
    @niveaux = Itineraire::NIVEAUX
  end
  
  # Détails d'un itinéraire spécifique
  def show
    @itineraire = Itineraire.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Itinéraire non trouvé."
    redirect_to itineraires_path
  end
end
