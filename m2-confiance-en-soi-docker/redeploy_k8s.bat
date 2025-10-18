@echo off
echo ========================================
echo Redéploiement de l'application dans Kubernetes
echo ========================================

cd /d "%~dp0"

echo.
echo [1/6] Construction de l'image backend...
docker build -t confiance-en-soi-back:latest ./back

echo.
echo [2/6] Construction de l'image frontend...
docker build -t confiance-en-soi-front:latest ./front/frontend

echo.
echo [3/6] Suppression des anciennes images de Minikube...
echo Suppression de l'ancienne image backend (peut échouer si elle n'existe pas)...
minikube image rm docker.io/library/confiance-en-soi-back:latest 2>nul
echo Suppression de l'ancienne image frontend (peut échouer si elle n'existe pas)...
kubectl delete pods -l app=confiance-en-soi-front -n confiance-sandrine-v1 2>nul
timeout /t 5 /nobreak >nul
minikube image rm docker.io/library/confiance-en-soi-front:latest 2>nul

echo.
echo [4/6] Chargement des nouvelles images dans Minikube...
minikube image load confiance-en-soi-back:latest
minikube image load confiance-en-soi-front:latest

echo.
echo [5/6] Application des configurations Kubernetes...
kubectl apply -f k8s/01-namespace.yaml
kubectl apply -f k8s/02-back-configmap.yaml
kubectl apply -f k8s/03-front-configmap.yaml
kubectl apply -f k8s/04-mariadb.yaml
kubectl apply -f k8s/05-deployment_backend.yaml
kubectl apply -f k8s/06-deployment_frontend.yaml
kubectl apply -f k8s/07-service_backend.yaml
kubectl apply -f k8s/08-service_frontend.yaml

echo.
echo [6/6] Redémarrage des déploiements...
kubectl rollout restart deployment confiance-en-soi-back -n confiance-sandrine-v1
kubectl rollout restart deployment confiance-en-soi-front -n confiance-sandrine-v1

echo.
echo ========================================
echo Déploiement terminé !
echo ========================================
echo.
echo Attendez quelques secondes que les pods démarrent, puis:
echo   - Frontend: http://127.0.0.1
echo   - Backend:  http://192.168.49.2:30888
echo.
echo Pour voir l'état des pods:
echo   kubectl get pods -n confiance-sandrine-v1
echo.
echo Pour voir les logs du frontend:
echo   kubectl logs -l app=confiance-en-soi-front -n confiance-sandrine-v1 --tail=30
echo.

pause
