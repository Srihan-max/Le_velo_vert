# Contrôleur CRUD pour la gestion des itinéraires (zone admin)
class Admin::ItinerairesController < Admin::BaseController
  before_action :set_itineraire, only: [:show, :edit, :update, :destroy]
  
  # Liste des itinéraires
  def index
    @itineraires = Itineraire.all
  end
  
  # Afficher un itinéraire
  def show
  end
  
  # Nouvel itinéraire
  def new
    @itineraire = Itineraire.new
  end
  
  # Créer un itinéraire
  def create
    @itineraire = Itineraire.new(itineraire_params)
    
    if @itineraire.save
      flash[:notice] = "Itinéraire créé avec succès."
      redirect_to admin_itineraire_path(@itineraire)
    else
      flash.now[:alert] = "Erreur lors de la création de l'itinéraire."
      render :new, status: :unprocessable_entity
    end
  end
  
  # Éditer un itinéraire
  def edit
  end
  
  # Mettre à jour un itinéraire
  def update
    if @itineraire.update(itineraire_params)
      flash[:notice] = "Itinéraire mis à jour avec succès."
      redirect_to admin_itineraire_path(@itineraire)
    else
      flash.now[:alert] = "Erreur lors de la mise à jour."
      render :edit, status: :unprocessable_entity
    end
  end
  
  # Supprimer un itinéraire
  def destroy
    @itineraire.destroy
    flash[:notice] = "Itinéraire supprimé avec succès."
    redirect_to admin_itineraires_path
  end
  
  private
  
  def set_itineraire
    @itineraire = Itineraire.find(params[:id])
  end
  
  def itineraire_params
    params.require(:itineraire).permit(:nom, :description, :distance_km, :duree_minutes, :niveau)
  end
end
