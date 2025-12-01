# Modèle représentant une réservation de vélo
class Reservation < ApplicationRecord
  # Associations
  belongs_to :velo
  
  # Validations
  validates :nom, presence: true
  validates :prenom, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :telephone, presence: true
  validates :date_debut, presence: true
  validates :date_fin, presence: true
  validate :date_fin_apres_date_debut
  
  # Scope
  scope :recentes, -> { order(created_at: :desc) }
  scope :a_venir, -> { where('date_debut > ?', Date.today) }
  scope :en_cours, -> { where('date_debut <= ? AND date_fin >= ?', Date.today, Date.today) }
  
  # Validation personnalisée
  def date_fin_apres_date_debut
    return if date_fin.blank? || date_debut.blank?
    
    if date_fin < date_debut
      errors.add(:date_fin, "doit être après la date de début")
    end
  end
  
  # Calcul de la durée en jours
  def duree_jours
    return 0 if date_debut.blank? || date_fin.blank?
    (date_fin - date_debut).to_i + 1
  end
  
  # Nom complet du client
  def nom_complet
    "#{prenom} #{nom}"
  end
end
