# Contrôleur pour la gestion des réservations (partie publique)
class ReservationsController < ApplicationController
  # Formulaire de nouvelle réservation
  def new
    @reservation = Reservation.new
    @velos = Velo.disponibles
  end
  
  # Création d'une réservation
  def create
    @reservation = Reservation.new(reservation_params)
    
    if @reservation.save
      flash[:notice] = "Votre réservation a été enregistrée avec succès ! Nous vous contacterons bientôt."
      redirect_to reservation_path(@reservation)
    else
      @velos = Velo.disponibles
      flash.now[:alert] = "Une erreur s'est produite. Veuillez vérifier les informations."
      render :new, status: :unprocessable_entity
    end
  end
  
  # Page de confirmation de réservation
  def show
    @reservation = Reservation.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Réservation non trouvée."
    redirect_to root_path
  end
  
  private
  
  def reservation_params
    params.require(:reservation).permit(
      :nom, :prenom, :email, :telephone, 
      :velo_id, :date_debut, :date_fin, :commentaire
    )
  end
end
