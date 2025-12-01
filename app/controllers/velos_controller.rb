# Contrôleur pour la gestion des vélos (partie publique)
class VelosController < ApplicationController
  # Liste de tous les vélos
  def index
    @velos = if params[:type].present?
      Velo.par_type(params[:type])
    else
      Velo.all
    end
    
    @types = Velo::TYPES
  end
  
  # Détails d'un vélo spécifique
  def show
    @velo = Velo.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Vélo non trouvé."
    redirect_to velos_path
  end
end
