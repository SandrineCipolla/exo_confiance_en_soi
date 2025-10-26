@echo off
REM =====================================================
REM Script de deploiement sur Azure Kubernetes Service
REM =====================================================

echo.
echo ========================================
echo    DEPLOIEMENT SUR AZURE AKS
echo ========================================
echo.

REM Variables
set DOCKER_USER=sancci
set BACKEND_IMAGE=%DOCKER_USER%/confiance-en-soi-back
set FRONTEND_IMAGE=%DOCKER_USER%/confiance-en-soi-front
set TAG=latest

echo [1/6] Verification du contexte kubectl...
kubectl config current-context
echo.

echo [2/6] Construction de l'image Docker BACKEND...
cd m2-confiance-en-soi-docker\back
docker build -t %BACKEND_IMAGE%:%TAG% .
if errorlevel 1 (
    echo ERREUR: Echec du build backend
    exit /b 1
)
echo ✅ Backend image built successfully
cd ..\..
echo.

echo [3/6] Construction de l'image Docker FRONTEND...
cd m2-confiance-en-soi-docker\front\frontend
docker build -t %FRONTEND_IMAGE%:%TAG% .
if errorlevel 1 (
    echo ERREUR: Echec du build frontend
    exit /b 1
)
echo ✅ Frontend image built successfully
cd ..\..\..
echo.

echo [4/6] Push des images vers Docker Hub...
echo Connexion a Docker Hub (entrez vos identifiants si demandes)...
docker login
echo.
echo Push de l'image backend...
docker push %BACKEND_IMAGE%:%TAG%
if errorlevel 1 (
    echo ERREUR: Echec du push backend
    exit /b 1
)
echo ✅ Backend image pushed
echo.
echo Push de l'image frontend...
docker push %FRONTEND_IMAGE%:%TAG%
if errorlevel 1 (
    echo ERREUR: Echec du push frontend
    exit /b 1
)
echo ✅ Frontend image pushed
echo.

echo [5/6] Creation du namespace si necessaire...
kubectl create namespace confiance-sandrine-v1 2>nul
echo.

echo [6/6] Deploiement sur AKS...
echo Application des configurations Kubernetes...
kubectl apply -f m2-confiance-en-soi-docker\k8s-aks\ -n confiance-sandrine-v1
if errorlevel 1 (
    echo ERREUR: Echec du deploiement
    exit /b 1
)
echo.

echo Redemarrage des deployments...
kubectl rollout restart deployment confiance-en-soi-back -n confiance-sandrine-v1
kubectl rollout restart deployment confiance-en-soi-front -n confiance-sandrine-v1
echo.

echo ========================================
echo    DEPLOIEMENT TERMINE !
echo ========================================
echo.
echo Verification de l'etat des pods:
kubectl get pods -n confiance-sandrine-v1
echo.
echo Verification des services:
kubectl get services -n confiance-sandrine-v1
echo.
echo Pour voir les logs:
echo   Backend:  kubectl logs -l app=confiance-en-soi-back -n confiance-sandrine-v1
echo   Frontend: kubectl logs -l app=confiance-en-soi-front -n confiance-sandrine-v1
echo.
