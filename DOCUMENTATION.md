# Le Vélo Vert - Documentation Développeur

## Vue d'ensemble

Application Rails 7 complète pour la location de vélos avec système de réservation en ligne et panneau d'administration.

## Architecture MVC

### Modèles (Models)

#### Velo
- **Attributs** : nom, type_velo, description, tarif_heure, tarif_jour, disponible
- **Validations** : Présence de tous les champs, tarifs numériques > 0
- **Scopes** : `disponibles`, `par_type`
- **Constante** : TYPES (liste des types de vélos)

#### Itineraire
- **Attributs** : nom, description, distance_km, duree_minutes, niveau
- **Validations** : Présence, distance et durée > 0, niveau dans la liste
- **Scopes** : `par_niveau`, `recents`
- **Constante** : NIVEAUX (Débutant, Intermédiaire, Sportif)
- **Méthode** : `duree_formattee` (convertit minutes en heures/minutes)

#### Actualite
- **Attributs** : titre, contenu, date_publication
- **Validations** : Présence de tous les champs
- **Scopes** : `publiees`, `recentes`
- **Méthodes** : `resume(longueur)`, `publie?`

#### Reservation
- **Attributs** : nom, prenom, email, telephone, velo_id, date_debut, date_fin, commentaire
- **Associations** : `belongs_to :velo`
- **Validations** : Présence, format email, dates cohérentes
- **Scopes** : `recentes`, `a_venir`, `en_cours`
- **Méthodes** : `duree_jours`, `nom_complet`

#### Admin
- **Attributs** : email, password_digest
- **Sécurité** : `has_secure_password` (bcrypt)
- **Validations** : Email unique et valide, mot de passe ≥ 6 caractères

### Contrôleurs (Controllers)

#### Pages publiques
- **PagesController** : Accueil, sécurité
- **VelosController** : Liste et détails des vélos (index, show)
- **ItinerairesController** : Liste et détails des itinéraires (index, show)
- **ActualitesController** : Liste et détails des actualités (index, show)
- **ReservationsController** : Création de réservations (new, create, show)

#### Zone admin
- **Admin::SessionsController** : Authentification (login, logout)
- **Admin::DashboardController** : Tableau de bord avec statistiques
- **Admin::VelosController** : CRUD complet des vélos
- **Admin::ItinerairesController** : CRUD complet des itinéraires
- **Admin::ActualitesController** : CRUD complet des actualités
- **Admin::ReservationsController** : Liste et suppression des réservations

### Routes (Routes)

```ruby
# Pages publiques
root 'pages#home'
get 'securite', to: 'pages#securite'

resources :velos, only: [:index, :show]
resources :itineraires, only: [:index, :show]
resources :actualites, only: [:index, :show]
resources :reservations, only: [:new, :create, :show]

# Zone admin
namespace :admin do
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  root 'dashboard#index'
  
  resources :velos
  resources :itineraires
  resources :actualites
  resources :reservations, only: [:index, :show, :destroy]
end
```

### Vues (Views)

#### Layouts
- **application.html.erb** : Layout principal du site public
  - Header avec navigation
  - Flash messages
  - Footer avec informations de contact
  
- **admin.html.erb** : Layout de la zone admin
  - Header admin avec navigation spécifique
  - Style différent (fond gris)

#### Pages principales
- **pages/home.html.erb** : Page d'accueil avec hero, features, aperçus
- **pages/securite.html.erb** : Guide de sécurité complet

#### Vélos
- **velos/index.html.erb** : Grille de vélos avec filtres par type
- **velos/show.html.erb** : Détails d'un vélo avec sidebar de réservation

#### Itinéraires
- **itineraires/index.html.erb** : Liste d'itinéraires avec filtres par niveau
- **itineraires/show.html.erb** : Détails d'un itinéraire avec infos pratiques

#### Actualités
- **actualites/index.html.erb** : Liste des articles publiés
- **actualites/show.html.erb** : Article complet

#### Réservations
- **reservations/new.html.erb** : Formulaire de réservation
- **reservations/show.html.erb** : Confirmation avec récapitulatif

#### Admin
- Vues CRUD complètes pour chaque ressource
- Dashboard avec statistiques
- Formulaires de connexion

## Base de données

### Tables

```ruby
# velos
- id (primary key)
- nom (string, not null)
- type_velo (string, not null, indexed)
- description (text, not null)
- tarif_heure (decimal(8,2), not null)
- tarif_jour (decimal(8,2), not null)
- disponible (boolean, default: true, indexed)
- created_at, updated_at

# itineraires
- id (primary key)
- nom (string, not null)
- description (text, not null)
- distance_km (decimal(6,2), not null)
- duree_minutes (integer, not null)
- niveau (string, not null, indexed)
- created_at, updated_at

# actualites
- id (primary key)
- titre (string, not null)
- contenu (text, not null)
- date_publication (date, not null, indexed)
- created_at, updated_at

# reservations
- id (primary key)
- nom (string, not null)
- prenom (string, not null)
- email (string, not null, indexed)
- telephone (string, not null)
- velo_id (foreign key, not null)
- date_debut (date, not null, indexed)
- date_fin (date, not null, indexed)
- commentaire (text)
- created_at, updated_at

# admins
- id (primary key)
- email (string, not null, unique indexed)
- password_digest (string, not null)
- created_at, updated_at
```

## Styles CSS

### Variables CSS
```css
--primary-green: #2d7a3e
--secondary-green: #4caf50
--light-green: #81c784
--dark-green: #1b5e20
--blue-accent: #2196f3
```

### Composants principaux
- Grids responsive (CSS Grid et Flexbox)
- Cards avec hover effects
- Formulaires stylisés
- Badges colorés par statut/niveau
- Tables admin
- Boutons avec transitions
- Layout responsive (mobile-first)

### Points de rupture
- Mobile : < 480px
- Tablette : < 768px
- Desktop : > 768px

## Fonctionnalités clés

### Authentification
- Système basé sur sessions
- Mot de passe haché avec bcrypt
- Protection des routes admin avec `before_action :require_admin`
- Helper methods : `current_admin`, `logged_in?`

### Filtres
- Vélos par type
- Itinéraires par niveau
- Actualités publiées automatiquement par date

### Validations
- Côté serveur (modèles ActiveRecord)
- Messages d'erreur en français
- Format email validé
- Cohérence des dates (fin > début)

### SEO
- Titres de page dynamiques avec `content_for :title`
- Meta tags CSRF
- URLs sémantiques (RESTful)

### Internationalisation
- Locale par défaut : français
- Formats de date personnalisés
- Messages d'erreur traduits

## Sécurité

### Mesures implémentées
- Tokens CSRF activés
- Protection contre les injections SQL (ActiveRecord)
- Mots de passe hashés (bcrypt)
- Validation des entrées utilisateur
- Strong parameters dans les contrôleurs
- Sessions sécurisées

### À ajouter en production
- HTTPS forcé
- Rate limiting
- Protection contre les attaques par force brute
- Validation côté client (JavaScript)
- Upload d'images sécurisé
- Backup automatique de la base de données

## Extensions possibles

### Fonctionnalités additionnelles
1. **Upload d'images**
   - Photos des vélos et itinéraires
   - Gem : CarrierWave ou ActiveStorage

2. **Système de paiement**
   - Stripe ou PayPal
   - Caution en ligne

3. **Notifications email**
   - Confirmation de réservation
   - Gem : Action Mailer + service SMTP

4. **Calendrier de disponibilité**
   - Vue calendrier pour les vélos
   - Gem : FullCalendar

5. **Gestion multi-langues**
   - Support anglais/espagnol
   - Utilisation complète de I18n

6. **API REST**
   - Pour applications mobiles
   - Format JSON

7. **Dashboard analytics**
   - Statistiques avancées
   - Graphiques (Chart.js)

8. **Système de commentaires**
   - Avis clients sur les vélos
   - Notation par étoiles

9. **Export PDF**
   - Factures de réservation
   - Gem : Prawn ou WickedPDF

10. **Géolocalisation**
    - Carte interactive des itinéraires
    - Google Maps API

## Tests

### À implémenter
```ruby
# Test unitaires (RSpec ou Minitest)
- Validations des modèles
- Méthodes des modèles
- Scopes

# Tests d'intégration
- Parcours utilisateur complet
- Formulaires de réservation
- Authentification admin

# Tests système
- Navigation complète
- JavaScript si ajouté
```

## Performance

### Optimisations possibles
- Cache fragment pour la page d'accueil
- Eager loading (N+1 queries)
- Index sur les colonnes fréquemment recherchées
- CDN pour les assets en production
- Pagination (gem Kaminari ou Pagy)
- Background jobs (Sidekiq) pour les emails

## Maintenance

### Tâches régulières
- Backup de la base de données
- Mise à jour des gems (`bundle update`)
- Vérification des logs
- Nettoyage des anciennes réservations
- Monitoring de la disponibilité

### Commandes utiles
```bash
# Vérifier les gems obsolètes
bundle outdated

# Mettre à jour Rails
bundle update rails

# Nettoyer les logs
rake log:clear

# Vérifier la sécurité
bundle audit
```

## Support navigateurs

### Testés et compatibles
- Chrome/Edge (dernières versions)
- Firefox (dernières versions)
- Safari (dernières versions)
- Mobile Safari (iOS 12+)
- Chrome Mobile (Android 8+)

## Crédits

- **Framework** : Ruby on Rails 7.0
- **Base de données** : SQLite3 (dev) / PostgreSQL (prod recommandé)
- **Authentification** : bcrypt
- **CSS** : CSS3 pur (pas de framework)
- **Icônes** : Emojis Unicode

---

**Développé avec ❤️ pour une mobilité douce et écologique 🚴🌱**
