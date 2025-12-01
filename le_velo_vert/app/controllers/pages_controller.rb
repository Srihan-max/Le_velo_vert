# Contrôleur pour les pages statiques du site
class PagesController < ApplicationController
  # Page d'accueil
  def home
    @velos_disponibles = Velo.disponibles.limit(3)
    @actualites_recentes = Actualite.publiees.limit(3)
    @itineraires_populaires = Itineraire.recents.limit(3)
  end
  
  # Page des conseils de sécurité
  def securite
    # Page statique, pas de logique particulière
  end
end
