# Modèle représentant un itinéraire touristique
class Itineraire < ApplicationRecord
  # Validations
  validates :nom, presence: true
  validates :description, presence: true
  validates :distance_km, presence: true, numericality: { greater_than: 0 }
  validates :duree_minutes, presence: true, numericality: { greater_than: 0 }
  validates :niveau, presence: true, inclusion: { in: ['Débutant', 'Intermédiaire', 'Sportif'] }
  
  # Niveaux disponibles
  NIVEAUX = ['Débutant', 'Intermédiaire', 'Sportif'].freeze
  
  # Scope
  scope :par_niveau, ->(niveau) { where(niveau: niveau) }
  scope :recents, -> { order(created_at: :desc) }
  
  # Méthode pour formater la durée
  def duree_formattee
    heures = duree_minutes / 60
    minutes = duree_minutes % 60
    
    if heures > 0
      "#{heures}h#{minutes > 0 ? " #{minutes}min" : ''}"
    else
      "#{minutes} min"
    end
  end
end
