# Contrôleur CRUD pour la gestion des vélos (zone admin)
class Admin::VelosController < Admin::BaseController
  before_action :set_velo, only: [:show, :edit, :update, :destroy]
  
  # Liste des vélos
  def index
    @velos = Velo.all
  end
  
  # Afficher un vélo
  def show
  end
  
  # Nouveau vélo
  def new
    @velo = Velo.new
  end
  
  # Créer un vélo
  def create
    @velo = Velo.new(velo_params)
    
    if @velo.save
      flash[:notice] = "Vélo créé avec succès."
      redirect_to admin_velo_path(@velo)
    else
      flash.now[:alert] = "Erreur lors de la création du vélo."
      render :new, status: :unprocessable_entity
    end
  end
  
  # Éditer un vélo
  def edit
  end
  
  # Mettre à jour un vélo
  def update
    if @velo.update(velo_params)
      flash[:notice] = "Vélo mis à jour avec succès."
      redirect_to admin_velo_path(@velo)
    else
      flash.now[:alert] = "Erreur lors de la mise à jour."
      render :edit, status: :unprocessable_entity
    end
  end
  
  # Supprimer un vélo
  def destroy
    @velo.destroy
    flash[:notice] = "Vélo supprimé avec succès."
    redirect_to admin_velos_path
  end
  
  private
  
  def set_velo
    @velo = Velo.find(params[:id])
  end
  
  def velo_params
    params.require(:velo).permit(:nom, :type_velo, :description, :tarif_heure, :tarif_jour, :disponible)
  end
end
