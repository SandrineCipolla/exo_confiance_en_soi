@echo off
REM =====================================================
REM Script pour arrêter le cluster AKS et économiser
REM Coût quand arrêté : ~0.02€/jour (seulement le stockage)
REM =====================================================

echo.
echo ========================================
echo    ARRET DU CLUSTER AZURE AKS
echo ========================================
echo.

echo [INFO] Verification de la connexion Azure...
az account show >nul 2>&1
if errorlevel 1 (
    echo [ERREUR] Vous n'êtes pas connecté à Azure.
    echo Veuillez vous connecter avec: az login
    exit /b 1
)

echo [INFO] Compte Azure actif:
az account show --query "name" -o tsv
echo.

echo [1/2] Arrêt du cluster AKS 'confiance'...
echo [INFO] Cela va arrêter toutes les VMs mais garder la configuration
echo [INFO] Coût pendant l'arrêt : ~0.02€/jour (seulement le stockage PVC)
echo.

az aks stop --resource-group confiance-en-soi --name confiance

if errorlevel 1 (
    echo.
    echo [ERREUR] Echec de l'arrêt du cluster
    exit /b 1
)

echo.
echo ========================================
echo    CLUSTER ARRETE AVEC SUCCES !
echo ========================================
echo.
echo [OK] Le cluster AKS est maintenant arrêté
echo [OK] Vos données sont conservées dans le PersistentVolume
echo [OK] La configuration est préservée
echo.
echo Pour redémarrer le cluster, lancez:
echo   start_aks.bat
echo.
echo Temps de redémarrage : 2-3 minutes
echo.
