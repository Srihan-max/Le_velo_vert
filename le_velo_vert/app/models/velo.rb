# Modèle représentant un vélo disponible à la location
class Velo < ApplicationRecord
  # === Image attachée ===
  has_one_attached :image
  # Validations
  validates :nom, presence: true
  validates :type_velo, presence: true
  validates :description, presence: true
  validates :tarif_heure, presence: true, numericality: { greater_than: 0 }
  validates :tarif_jour, presence: true, numericality: { greater_than: 0 }
  validates :disponible, inclusion: { in: [true, false] }
  
  # Types de vélos disponibles
  TYPES = ['VTT', 'Vélo de ville', 'Vélo électrique', 'Vélo enfant', 'Vélo cargo'].freeze
  
  # Scope pour les vélos disponibles
  scope :disponibles, -> { where(disponible: true) }
  scope :par_type, ->(type) { where(type_velo: type) }
  
  # Méthode pour afficher le statut
  def statut_disponibilite
    disponible ? 'Disponible' : 'Indisponible'
  end
end
