# Contrôleur CRUD pour la gestion des actualités (zone admin)
class Admin::ActualitesController < Admin::BaseController
  before_action :set_actualite, only: [:show, :edit, :update, :destroy]
  
  # Liste des actualités
  def index
    @actualites = Actualite.recentes
  end
  
  # Afficher une actualité
  def show
  end
  
  # Nouvelle actualité
  def new
    @actualite = Actualite.new
    @actualite.date_publication = Date.today
  end
  
  # Créer une actualité
  def create
    @actualite = Actualite.new(actualite_params)
    
    if @actualite.save
      flash[:notice] = "Actualité créée avec succès."
      redirect_to admin_actualite_path(@actualite)
    else
      flash.now[:alert] = "Erreur lors de la création de l'actualité."
      render :new, status: :unprocessable_entity
    end
  end
  
  # Éditer une actualité
  def edit
  end
  
  # Mettre à jour une actualité
  def update
    if @actualite.update(actualite_params)
      flash[:notice] = "Actualité mise à jour avec succès."
      redirect_to admin_actualite_path(@actualite)
    else
      flash.now[:alert] = "Erreur lors de la mise à jour."
      render :edit, status: :unprocessable_entity
    end
  end
  
  # Supprimer une actualité
  def destroy
    @actualite.destroy
    flash[:notice] = "Actualité supprimée avec succès."
    redirect_to admin_actualites_path
  end
  
  private
  
  def set_actualite
    @actualite = Actualite.find(params[:id])
  end
  
  def actualite_params
    params.require(:actualite).permit(:titre, :contenu, :date_publication)
  end
end
