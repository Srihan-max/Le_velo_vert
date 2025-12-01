module ApplicationHelper
  # Méthodes d'aide disponibles dans toutes les vues
  
  def page_title(title)
    content_for(:title, title)
  end
end
