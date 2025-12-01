# Contrôleur pour la gestion des réservations (zone admin)
class Admin::ReservationsController < Admin::BaseController
  before_action :set_reservation, only: [:show, :destroy]
  
  # Liste des réservations
  def index
    @reservations = Reservation.recentes
  end
  
  # Afficher une réservation
  def show
  end
  
  # Supprimer une réservation
  def destroy
    @reservation.destroy
    flash[:notice] = "Réservation supprimée avec succès."
    redirect_to admin_reservations_path
  end
  
  private
  
  def set_reservation
    @reservation = Reservation.find(params[:id])
  end
end
