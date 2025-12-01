# Le Vélo Vert - Site de location de vélos

Site vitrine et réservation en ligne pour une entreprise de location de vélos écologiques.

## Stack Technique

- **Backend**: Ruby on Rails 7.0
- **Frontend**: HTML5, CSS3 (responsive)
- **Base de données**: SQLite3

## Fonctionnalités

- ✅ Page d'accueil avec présentation de l'entreprise
- ✅ Catalogue des vélos avec détails
- ✅ Itinéraires touristiques
- ✅ Système de réservation en ligne
- ✅ Conseils de sécurité
- ✅ Blog d'actualités et événements
- ✅ Zone administrateur (CRUD complet)

## Installation

### Prérequis

- Ruby 3.0 ou supérieur
- Rails 7.0
- SQLite3

### Installation des dépendances

```bash
bundle install
```

### Configuration de la base de données

```bash
rails db:create
rails db:migrate
rails db:seed
```

### Lancement du serveur

```bash
rails server
```

Le site sera accessible à l'adresse: http://localhost:3000

## Structure du projet

```
le_velo_vert/
├── app/
│   ├── controllers/      # Contrôleurs
│   ├── models/           # Modèles ActiveRecord
│   ├── views/            # Vues ERB
│   └── assets/           # CSS, images
├── config/
│   ├── routes.rb         # Configuration des routes
│   └── database.yml      # Configuration BDD
├── db/
│   ├── migrate/          # Migrations
│   └── seeds.rb          # Données de démonstration
└── public/               # Fichiers statiques
```

## Compte administrateur par défaut

- Email: admin@levelopert.fr
- Mot de passe: admin123

⚠️ Pensez à changer ces identifiants en production !

## Thème et Design

Le site utilise un thème écologique avec des tons verts, blancs et bleus pour refléter les valeurs de mobilité douce et de développement durable.

## Développement

Ce projet utilise une architecture MVC classique Rails avec des routes REST.

## License

Ce projet est sous licence privée.
