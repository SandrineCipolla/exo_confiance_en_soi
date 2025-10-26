@echo off
REM =====================================================
REM Script pour démarrer le cluster AKS
REM Utilisez ce script avant votre démo/présentation
REM =====================================================

echo.
echo ========================================
echo    DEMARRAGE DU CLUSTER AZURE AKS
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

echo [1/3] Démarrage du cluster AKS 'confiance'...
echo [INFO] Cela peut prendre 2-3 minutes...
echo.

az aks start --resource-group confiance-en-soi --name confiance

if errorlevel 1 (
    echo.
    echo [ERREUR] Echec du démarrage du cluster
    exit /b 1
)

echo.
echo [2/3] Configuration du contexte kubectl...
az aks get-credentials --resource-group confiance-en-soi --name confiance --overwrite-existing

echo.
echo [3/3] Vérification de l'état des pods...
echo.
kubectl get pods -n confiance-sandrine-v1

echo.
echo ========================================
echo    CLUSTER DEMARRE AVEC SUCCES !
echo ========================================
echo.
echo [OK] Tous les pods sont en cours de démarrage
echo.

echo Récupération de l'URL publique...
for /f "tokens=*" %%i in ('kubectl get service confiance-en-soi-front -n confiance-sandrine-v1 -o jsonpath^="{.status.loadBalancer.ingress[0].ip}"') do set PUBLIC_IP=%%i

echo.
echo ========================================
echo    VOTRE APPLICATION EST ACCESSIBLE :
echo ========================================
echo.
echo    URL : http://%PUBLIC_IP%
echo.
echo ========================================
echo.
echo Commandes utiles :
echo   - Voir les pods     : kubectl get pods -n confiance-sandrine-v1
echo   - Voir les logs     : kubectl logs -l app=confiance-en-soi-front -n confiance-sandrine-v1
echo   - Arrêter le cluster : stop_aks.bat
echo.
