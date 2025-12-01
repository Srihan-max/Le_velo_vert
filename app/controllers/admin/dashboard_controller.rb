# Contrôleur pour le tableau de bord administrateur
class Admin::DashboardController < Admin::BaseController
  def index
    @total_velos = Velo.count
    @velos_disponibles = Velo.disponibles.count
    @total_reservations = Reservation.count
    @reservations_recentes = Reservation.recentes.limit(5)
    @total_itineraires = Itineraire.count
    @total_actualites = Actualite.count
  end
end
