# Guide d'installation - Le Vélo Vert

## Prérequis

Avant de commencer, assurez-vous d'avoir installé :

### Sur Windows :

1. **Ruby** (version 3.0 ou supérieure)
   - Téléchargez RubyInstaller depuis : https://rubyinstaller.org/
   - Installez la version recommandée (avec Devkit)
   - Pendant l'installation, cochez "Add Ruby executables to your PATH"
   - À la fin, laissez l'installateur configurer MSYS2

2. **Rails**
   ```powershell
   gem install rails -v 7.0.0
   gem 'rails', '~> 7.0.10'
   
   ```

3. **Bundler**
   ```powershell
   gem install bundler
   ```

## Installation du projet

### 1. Naviguer vers le dossier du projet
```powershell
cd C:\Users\mathi\Downloads\le_velo_vert
```

### 2. Installer les dépendances
```powershell
bundle install
```

Si vous rencontrez des erreurs, essayez :
```powershell
bundle update
```

### 3. Créer la base de données
```powershell
rails db:create
```

### 4. Exécuter les migrations
```powershell
rails db:migrate
```

### 5. Charger les données de démonstration
```powershell
rails db:seed
```

Cette commande va créer :
- 5 vélos (VTT, vélo de ville, électrique, enfant, cargo)
- 5 itinéraires touristiques
- 3 articles d'actualités
- 1 compte administrateur (admin@levelopert.fr / admin123)

### Ajouter les images pour les vélos

## Crée les tables nécessaires pour stocker les images
```
bin/rails active_storage:install
bin/rails db:migrate
```

## Lancement de l'application

### Démarrer le serveur Rails
```powershell
rails server
```

ou en version courte :
```powershell
rails s
```

Le serveur démarre sur **http://localhost:3000**

### Accéder à l'application

- **Site public** : http://localhost:3000
- **Page d'administration** : http://localhost:3000/admin/login
  - Email : admin@levelopert.fr
  - Mot de passe : admin123

## Structure du projet

```
le_velo_vert/
├── app/
│   ├── controllers/          # Logique métier
│   │   ├── pages_controller.rb
│   │   ├── velos_controller.rb
│   │   ├── itineraires_controller.rb
│   │   ├── actualites_controller.rb
│   │   ├── reservations_controller.rb
│   │   └── admin/            # Zone admin
│   │       ├── velos_controller.rb
│   │       ├── itineraires_controller.rb
│   │       ├── actualites_controller.rb
│   │       └── reservations_controller.rb
│   │
│   ├── models/               # Modèles de données
│   │   ├── velo.rb
│   │   ├── itineraire.rb
│   │   ├── actualite.rb
│   │   ├── reservation.rb
│   │   └── admin.rb
│   │
│   ├── views/                # Templates HTML/ERB
│   │   ├── layouts/
│   │   │   ├── application.html.erb
│   │   │   └── admin.html.erb
│   │   ├── pages/
│   │   ├── velos/
│   │   ├── itineraires/
│   │   ├── actualites/
│   │   ├── reservations/
│   │   └── admin/
│   │
│   └── assets/
│       └── stylesheets/
│           └── application.css  # Styles CSS
│
├── config/
│   ├── routes.rb             # Configuration des routes
│   ├── database.yml          # Configuration BDD
│   └── locales/
│       └── fr.yml            # Traductions françaises
│
├── db/
│   ├── migrate/              # Migrations de base de données
│   └── seeds.rb              # Données de test
│
└── public/                   # Fichiers statiques
```

## Commandes utiles

### Base de données

```powershell
# Réinitialiser la base de données
rails db:reset

# Supprimer et recréer
rails db:drop db:create db:migrate db:seed

# Vérifier l'état des migrations
rails db:migrate:status
```

### Console Rails

```powershell
# Ouvrir la console interactive
rails console

# Dans la console, vous pouvez :
Velo.count              # Compter les vélos
Admin.first             # Voir le premier admin
Reservation.all         # Lister toutes les réservations
```

### Génération de code

```powershell
# Générer un nouveau contrôleur
rails generate controller NomController

# Générer un nouveau modèle
rails generate model NomModele

# Voir toutes les routes
rails routes
```

## Fonctionnalités principales

### Pages publiques
- ✅ **Accueil** (/) - Présentation de l'entreprise
- ✅ **Catalogue des vélos** (/velos) - Liste et détails des vélos
- ✅ **Itinéraires** (/itineraires) - Parcours touristiques
- ✅ **Réservation** (/reservations/new) - Formulaire de réservation
- ✅ **Sécurité** (/securite) - Conseils de sécurité
- ✅ **Actualités** (/actualites) - Blog et événements

### Administration
- ✅ **Dashboard** - Vue d'ensemble des statistiques
- ✅ **Gestion des vélos** - CRUD complet
- ✅ **Gestion des itinéraires** - CRUD complet
- ✅ **Gestion des actualités** - CRUD complet
- ✅ **Suivi des réservations** - Consultation et suppression

## Personnalisation

### Modifier le thème

Les couleurs sont définies dans `app/assets/stylesheets/application.css` :

```css
:root {
  --primary-green: #2d7a3e;
  --secondary-green: #4caf50;
  --blue-accent: #2196f3;
  /* ... */
}
```

### Ajouter un administrateur

Dans la console Rails :

```ruby
Admin.create!(email: "nouveau@email.fr", password: "motdepasse123")
```

### Modifier les types de vélos

Dans `app/models/velo.rb`, modifiez la constante `TYPES` :

```ruby
TYPES = ['VTT', 'Vélo de ville', 'Vélo électrique', 'Vélo enfant', 'Vélo cargo'].freeze
```

## Déploiement

### Préparer pour la production

1. Modifier `config/database.yml` pour utiliser PostgreSQL ou MySQL
2. Configurer les variables d'environnement
3. Précompiler les assets :
   ```powershell
   rails assets:precompile
   ```

### Hébergement recommandé

- **Heroku** : Facile et gratuit pour commencer
- **Railway** : Simple et moderne
- **Render** : Bonne alternative gratuite
- **VPS** (OVH, AWS, DigitalOcean) : Pour plus de contrôle

## Dépannage

### Problème : "Gem not found"
```powershell
bundle install
```

### Problème : "Database does not exist"
```powershell
rails db:create
rails db:migrate
```

### Problème : "Port 3000 already in use"
```powershell
# Utiliser un autre port
rails s -p 3001
```

### Problème : Erreur de migration
```powershell
rails db:drop
rails db:create
rails db:migrate
rails db:seed
```

```
Première génération de code pour créer le site internet.
Adpation aux différentes versions de Ruby ou de rails.
Manque d'indications pour des nouvelles implatations de code.
Ajout d'apostrophe dans les codes HTML bousillant ainsi le code
```

## Support

Pour toute question ou problème :
- Consultez la documentation Rails : https://guides.rubyonrails.org/
- Forum Ruby : https://ruby-forum.com/
- Stack Overflow : https://stackoverflow.com/questions/tagged/ruby-on-rails

## Licence

Projet privé - Tous droits réservés

---

**Bon développement ! 🚴💚**
