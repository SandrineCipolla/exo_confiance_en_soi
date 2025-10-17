@echo off
echo ========================================
echo   GESTIONNAIRE D'ENVIRONNEMENTS
echo   CONFIANCE EN SOI - SANDRINE
echo ========================================
echo.
echo Choisissez votre environnement:
echo.
echo   1. ENVIRONNEMENT LOCAL (Docker Compose)
echo      - Port frontend: 3000
echo      - Port backend: 8889
echo      - Ideal pour le developpement
echo.
echo   2. ENVIRONNEMENT PRODUCTION (Kubernetes)
echo      - Port frontend: 30300
echo      - Port backend: 30888
echo      - Simule un environnement de production
echo.
echo   3. ARRETER TOUS LES ENVIRONNEMENTS
echo.
set /p choice="Votre choix (1, 2 ou 3): "

if "%choice%"=="1" (
    echo.
    echo Arret de l'environnement Kubernetes...
    call stop_k8s.bat > nul 2>&1
    echo Demarrage de l'environnement local...
    call restart_services.bat
) else if "%choice%"=="2" (
    echo.
    echo Arret de l'environnement local...
    docker-compose down > nul 2>&1
    echo Demarrage de l'environnement Kubernetes...
    call deploy_k8s.bat
) else if "%choice%"=="3" (
    echo.
    echo Arret de tous les environnements...
    docker-compose down > nul 2>&1
    call stop_k8s.bat > nul 2>&1
    echo Tous les environnements sont arretes.
    pause
) else (
    echo Choix invalide.
    pause
)
