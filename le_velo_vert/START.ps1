# Script de démarrage rapide pour Le Vélo Vert (PowerShell)
# Ce script configure et lance l'application Rails

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Le Vélo Vert - Démarrage rapide" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Vérifier si Ruby est installé
Write-Host "[1/6] Vérification de Ruby..." -ForegroundColor Cyan
try {
    $rubyVersion = ruby --version
    Write-Host "[OK] Ruby est installé : $rubyVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERREUR] Ruby n'est pas installé !" -ForegroundColor Red
    Write-Host ""
    Write-Host "Téléchargez Ruby depuis : https://rubyinstaller.org/" -ForegroundColor Yellow
    Write-Host "Installez la version 3.0 ou supérieure avec Devkit" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Appuyez sur Entrée pour quitter"
    exit 1
}
Write-Host ""

# Vérifier si Rails est installé
Write-Host "[2/6] Vérification de Rails..." -ForegroundColor Cyan
try {
    $railsVersion = rails --version
    Write-Host "[OK] Rails est installé : $railsVersion" -ForegroundColor Green
} catch {
    Write-Host "[ATTENTION] Rails n'est pas installé" -ForegroundColor Yellow
    Write-Host "Installation de Rails en cours..." -ForegroundColor Yellow
    gem install rails -v 7.0.0
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERREUR] Impossible d'installer Rails" -ForegroundColor Red
        Read-Host "Appuyez sur Entrée pour quitter"
        exit 1
    }
    Write-Host "[OK] Rails installé" -ForegroundColor Green
}
Write-Host ""

# Installer les gems
Write-Host "[3/6] Installation des dépendances..." -ForegroundColor Cyan
bundle install
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERREUR] Erreur lors de l'installation des gems" -ForegroundColor Red
    Write-Host "Essayez manuellement : bundle install" -ForegroundColor Yellow
    Read-Host "Appuyez sur Entrée pour quitter"
    exit 1
}
Write-Host "[OK] Dépendances installées" -ForegroundColor Green
Write-Host ""

# Créer la base de données si nécessaire
Write-Host "[4/6] Création de la base de données..." -ForegroundColor Cyan
if (-not (Test-Path "db\development.sqlite3")) {
    rails db:create
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERREUR] Impossible de créer la base de données" -ForegroundColor Red
        Read-Host "Appuyez sur Entrée pour quitter"
        exit 1
    }
    Write-Host "[OK] Base de données créée" -ForegroundColor Green
} else {
    Write-Host "[OK] Base de données existe déjà" -ForegroundColor Green
}
Write-Host ""

# Exécuter les migrations
Write-Host "[5/6] Exécution des migrations..." -ForegroundColor Cyan
rails db:migrate
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERREUR] Erreur lors des migrations" -ForegroundColor Red
    Read-Host "Appuyez sur Entrée pour quitter"
    exit 1
}
Write-Host "[OK] Migrations exécutées" -ForegroundColor Green
Write-Host ""

# Charger les données de démonstration
Write-Host "[6/6] Chargement des données de démonstration..." -ForegroundColor Cyan
rails db:seed
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ATTENTION] Erreur lors du chargement des données" -ForegroundColor Yellow
    Write-Host "Ce n'est pas bloquant, vous pouvez continuer" -ForegroundColor Yellow
} else {
    Write-Host "[OK] Données chargées" -ForegroundColor Green
}
Write-Host ""

Write-Host "========================================" -ForegroundColor Green
Write-Host "  Configuration terminée !" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "L'application va démarrer sur http://localhost:3000" -ForegroundColor Cyan
Write-Host ""
Write-Host "Pages importantes :" -ForegroundColor Yellow
Write-Host "  - Site public : http://localhost:3000" -ForegroundColor White
Write-Host "  - Admin : http://localhost:3000/admin/login" -ForegroundColor White
Write-Host ""
Write-Host "Identifiants admin :" -ForegroundColor Yellow
Write-Host "  - Email : admin@levelopert.fr" -ForegroundColor White
Write-Host "  - Mot de passe : admin123" -ForegroundColor White
Write-Host ""
Write-Host "Appuyez sur Ctrl+C pour arrêter le serveur" -ForegroundColor Yellow
Write-Host ""
Read-Host "Appuyez sur Entrée pour démarrer le serveur"

# Lancer le serveur
Write-Host "Démarrage du serveur Rails..." -ForegroundColor Cyan
Write-Host ""
rails server
