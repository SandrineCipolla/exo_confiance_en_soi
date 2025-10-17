@echo off
echo ========================================
echo   ARRET KUBERNETES - RETOUR EN LOCAL
echo ========================================

echo.
echo 1. Suppression des deployments...
kubectl delete -f k8s/deployment_frontend.yaml
kubectl delete -f k8s/deployment_backend.yaml
kubectl delete -f k8s/mariadb.yaml

echo.
echo 2. Suppression des services...
kubectl delete -f k8s/service_frontend.yaml
kubectl delete -f k8s/service_backend.yaml

echo.
echo 3. Suppression des configmaps...
kubectl delete -f k8s/mariadb-configmap.yaml

echo.
echo 4. Suppression du namespace...
kubectl delete -f k8s/namespace.yaml

echo.
echo ========================================
echo   ENVIRONNEMENT K8S ARRETE
echo ========================================
echo.
echo Pour revenir en mode local Docker Compose:
echo   .\restart_services.bat
echo.
echo L'application sera alors accessible sur:
echo   http://localhost:3000
echo.
pause
