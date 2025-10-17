@echo off
echo ========================================
echo   DEPLOIEMENT KUBERNETES - CONFIANCE EN SOI
echo   Environnement: Production (k8s)
echo ========================================

echo.
echo 1. Creation du namespace...
kubectl apply -f k8s/namespace.yaml

echo.
echo 2. Deploiement de la base de donnees MariaDB...
kubectl apply -f k8s/mariadb-configmap.yaml
kubectl apply -f k8s/mariadb.yaml

echo.
echo 3. Deploiement du backend...
kubectl apply -f k8s/deployment_backend.yaml
kubectl apply -f k8s/service_backend.yaml

echo.
echo 4. Deploiement du frontend...
kubectl apply -f k8s/deployment_frontend.yaml
kubectl apply -f k8s/service_frontend.yaml

echo.
echo 5. Attente que les pods soient prets...
kubectl wait --for=condition=ready pod --all -n confiance-sandrine-v1 --timeout=300s

echo.
echo 6. Recuperation de l'IP Minikube...
for /f %%i in ('minikube ip') do set MINIKUBE_IP=%%i

echo.
echo ========================================
echo   DEPLOIEMENT TERMINE !
echo   ENVIRONNEMENT PRODUCTION (Kubernetes)
echo ========================================
echo.
echo Acces a l'application de PRODUCTION:
echo   Frontend: http://%MINIKUBE_IP%:30300
echo   Backend:  http://%MINIKUBE_IP%:30888
echo.
echo ATTENTION: Ceci est l'environnement de PRODUCTION (k8s)
echo Pour l'environnement LOCAL, utilisez: .\restart_services.bat
echo   - Frontend local: http://localhost:3000
echo   - Backend local:  http://localhost:8889
echo.
echo Commandes utiles Kubernetes:
echo   kubectl get pods -n confiance-sandrine-v1
echo   kubectl get services -n confiance-sandrine-v1
echo   kubectl logs -f [nom-du-pod] -n confiance-sandrine-v1
echo.
pause
