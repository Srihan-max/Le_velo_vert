@echo off
REM Script de démarrage rapide pour Le Vélo Vert
REM Ce script configure et lance l'application Rails

echo.
echo ========================================
echo   Le Velo Vert - Demarrage rapide
echo ========================================
echo.

REM Vérifier si Ruby est installé
echo [1/6] Verification de Ruby...
ruby --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERREUR] Ruby n'est pas installe !
    echo.
    echo Telechargez Ruby depuis : https://rubyinstaller.org/
    echo Installez la version 3.0 ou superieure avec Devkit
    echo.
    pause
    exit /b 1
)
echo [OK] Ruby est installe
echo.

REM Vérifier si Rails est installé
echo [2/6] Verification de Rails...
rails --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ATTENTION] Rails n'est pas installe
    echo Installation de Rails en cours...
    gem install rails -v 7.0.0
    if %errorlevel% neq 0 (
        echo [ERREUR] Impossible d'installer Rails
        pause
        exit /b 1
    )
)
echo [OK] Rails est installe
echo.

REM Installer les gems
echo [3/6] Installation des dependances...
call bundle install
if %errorlevel% neq 0 (
    echo [ERREUR] Erreur lors de l'installation des gems
    echo Essayez manuellement : bundle install
    pause
    exit /b 1
)
echo [OK] Dependances installees
echo.

REM Créer la base de données si nécessaire
echo [4/6] Creation de la base de donnees...
if not exist "db\development.sqlite3" (
    call rails db:create
    if %errorlevel% neq 0 (
        echo [ERREUR] Impossible de creer la base de donnees
        pause
        exit /b 1
    )
    echo [OK] Base de donnees creee
) else (
    echo [OK] Base de donnees existe deja
)
echo.

REM Exécuter les migrations
echo [5/6] Execution des migrations...
call rails db:migrate
if %errorlevel% neq 0 (
    echo [ERREUR] Erreur lors des migrations
    pause
    exit /b 1
)
echo [OK] Migrations executees
echo.

REM Charger les données de démonstration
echo [6/6] Chargement des donnees de demonstration...
call rails db:seed
if %errorlevel% neq 0 (
    echo [ATTENTION] Erreur lors du chargement des donnees
    echo Ce n'est pas bloquant, vous pouvez continuer
)
echo [OK] Donnees chargees
echo.

echo ========================================
echo   Configuration terminee !
echo ========================================
echo.
echo L'application va demarrer sur http://localhost:3000
echo.
echo Pages importantes :
echo   - Site public : http://localhost:3000
echo   - Admin : http://localhost:3000/admin/login
echo.
echo Identifiants admin :
echo   - Email : admin@levelopert.fr
echo   - Mot de passe : admin123
echo.
echo Appuyez sur Ctrl+C pour arreter le serveur
echo.
pause

REM Lancer le serveur
echo Demarrage du serveur Rails...
echo.
call rails server
