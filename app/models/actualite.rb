# Modèle représentant un article d'actualité ou un événement
class Actualite < ApplicationRecord
  # Validations
  validates :titre, presence: true
  validates :contenu, presence: true
  validates :date_publication, presence: true
  
  # Scope
  scope :publiees, -> { where('date_publication <= ?', Date.today).order(date_publication: :desc) }
  scope :recentes, -> { order(date_publication: :desc) }
  
  # Méthode pour obtenir un résumé
  def resume(longueur = 200)
    return contenu if contenu.length <= longueur
    "#{contenu[0...longueur]}..."
  end
  
  # Vérifie si l'article est publié
  def publie?
    date_publication <= Date.today
  end
end
