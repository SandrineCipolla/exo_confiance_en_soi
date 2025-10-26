# m2-confiance-en-soi-docker

📦 Application d'affirmations positives avec Express (Node.js) et React + Vite, déployable en local (Docker Compose) et en "production" (Kubernetes/Minikube)

## 📋 Architecture

- **Backend** : Express.js avec Node.js 20
- **Frontend** : React + Vite avec TypeScript
- **Base de données** : MariaDB 11.8.3
- **Déploiement local** : Docker Compose
- **Déploiement Kubernetes local** : Minikube
- **Déploiement production** : Azure Kubernetes Service (AKS)

---

## 🌐 Application en production sur Azure

**🔗 URL publique : http://20.216.193.148**

L'application est déployée sur **Azure Kubernetes Service (AKS)** avec :
- ✅ Haute disponibilité
- ✅ Persistance des données (PersistentVolume 1Gi)
- ✅ IP publique accessible depuis Internet
- ✅ Cluster : France Central, Kubernetes v1.32.7

### Redéployer sur Azure AKS

```bash
deploy_aks.bat
```

### Récupérer l'URL Azure

```bash
kubectl get service confiance-en-soi-front -n confiance-sandrine-v1
```

📖 **[Documentation complète du déploiement AKS](m2-confiance-en-soi-docker/README.md)**

---

## 🚀 Démarrage rapide

### 🏠 Environnement LOCAL (Docker Compose)

**Pour le développement quotidien - Simple et rapide**

1. **Démarrer l'application** :
   ```bash
   docker compose up -d
   ```

2. **Accéder à l'application** :
   - Frontend : http://localhost:3001
   - Backend : http://localhost:8889

3. **Arrêter l'application** :
   ```bash
   docker compose down
   ```

**Commandes utiles** :
- Voir les logs en temps réel : `docker compose logs -f`
- Voir uniquement les logs du frontend : `docker compose logs -f frontend`
- Reconstruire après modification du code : `docker compose up -d --build`

---

### 🚀 Environnement "PRODUCTION" (Kubernetes/Minikube)

**Pour simuler un déploiement en production**

#### Prérequis
- Minikube installé et configuré
- kubectl installé

#### Première installation

1. **Démarrer Minikube** :
   ```bash
   minikube start
   ```

2. **Déployer l'application** :
   ```bash
   redeploy_k8s.bat
   ```
   
   Ce script va automatiquement :
   - Construire les images Docker backend et frontend
   - Supprimer les anciennes images de Minikube
   - Charger les nouvelles images dans Minikube
   - Appliquer toutes les configurations Kubernetes
   - Redémarrer les déploiements

3. **Accéder à l'application** :
   - Frontend : http://127.0.0.1
   - Backend : http://192.168.49.2:30888

#### Après un redémarrage de Minikube

Si vous avez arrêté Minikube (`minikube stop`) et que vous voulez redémarrer l'application :

1. Démarrer Minikube : `minikube start`
2. Relancer le script : `redeploy_k8s.bat`

**Commandes Kubernetes utiles** :
- Voir l'état des pods : `kubectl get pods -n confiance-sandrine-v1`
- Voir les logs du frontend : `kubectl logs -l app=confiance-en-soi-front -n confiance-sandrine-v1 --tail=30`
- Voir les logs du backend : `kubectl logs -l app=confiance-en-soi-back -n confiance-sandrine-v1 --tail=30`
- Voir tous les services : `kubectl get services -n confiance-sandrine-v1`

---

## 🔧 Configuration technique

### Variables d'environnement

L'application utilise des variables d'environnement pour la configuration. Créez un fichier `.env` à la racine du projet (voir `.env.example` pour un modèle).

⚠️ **Important** : Ne commitez jamais le fichier `.env` car il contient des informations sensibles.

#### Configuration du proxy Vite

L'application utilise le **proxy Vite** pour la communication entre frontend et backend :

- **En local (Docker Compose)** : Le proxy redirige vers `http://backend:8888`
- **En Kubernetes** : Le proxy redirige vers `http://confiance-en-soi-back:8888`

Cette configuration est automatiquement gérée via les variables d'environnement :
- `VITE_API_URL=` (vide pour utiliser des URLs relatives)
- `VITE_PROXY_TARGET` (configuré selon l'environnement)

---

## 📁 Structure du projet

```
m2-confiance-en-soi-docker/
├── back/                       # Backend Express.js
│   ├── app.js                 # Application principale
│   ├── Dockerfile             # Image Docker backend
│   ├── init.sql               # Script d'initialisation de la BDD
│   └── package.json
├── front/frontend/            # Frontend React + Vite
│   ├── src/
│   │   └── App.tsx           # Application React
│   ├── Dockerfile            # Image Docker frontend
│   ├── start.sh              # Script de démarrage
│   ├── vite.config.ts        # Configuration Vite avec proxy
│   └── package.json
├── k8s/                       # Configurations Kubernetes (ordre d'application)
│   ├── 01-namespace.yaml
│   ├── 02-back-configmap.yaml
│   ├── 03-front-configmap.yaml
│   ├── 04-mariadb.yaml
│   ├── 05-deployment_backend.yaml
│   ├── 06-deployment_frontend.yaml
│   ├── 07-service_backend.yaml
│   └── 08-service_frontend.yaml
├── compose.yaml               # Configuration Docker Compose
├── redeploy_k8s.bat          # Script de déploiement Kubernetes
└── README.md
```

---

## 🛠️ Développement

### Modifier le code

**Pour Docker Compose** :
- Les modifications sont automatiquement détectées grâce aux volumes
- Le serveur Vite se recharge automatiquement (HMR)
- Pour le backend, Nodemon redémarre automatiquement le serveur

**Pour Kubernetes** :
- Après modification du code, relancez `redeploy_k8s.bat`
- Les images seront reconstruites et rechargées dans Minikube

### Ports utilisés

- **Docker Compose** :
  - Frontend : 3001 → 3000 (conteneur)
  - Backend : 8889 → 8888 (conteneur)
  - Base de données : 3306 (interne uniquement)

- **Kubernetes** :
  - Frontend : 80 (LoadBalancer sur 127.0.0.1)
  - Backend : 30888 (NodePort)
  - Base de données : 3306 (interne uniquement)

---

## 🐛 Dépannage

### L'application ne démarre pas en local
- Vérifiez que Docker est bien démarré
- Vérifiez qu'aucun autre service n'utilise les ports 3001 ou 8889
- Essayez `docker compose down` puis `docker compose up -d --build`

### L'application ne fonctionne pas dans Kubernetes
- Vérifiez que Minikube est démarré : `minikube status`
- Vérifiez l'état des pods : `kubectl get pods -n confiance-sandrine-v1`
- Si un pod est en erreur, consultez ses logs : `kubectl logs <pod-name> -n confiance-sandrine-v1`
- Relancez le script de déploiement : `redeploy_k8s.bat`

### Erreurs de connexion au backend
- Vérifiez que la base de données est bien démarrée
- Consultez les logs du backend pour identifier l'erreur
- Vérifiez les variables d'environnement dans le fichier `.env`

---

## 📝 Notes importantes

- Les images Docker doivent être reconstruites après chaque modification du code pour Kubernetes
- Minikube ne persiste pas les images Docker après un `minikube stop`, d'où l'utilité du script `redeploy_k8s.bat`
- Le port 3001 a été choisi pour éviter les conflits avec d'autres services locaux

---

## 🔄 CI/CD Pipeline

Le projet utilise GitHub Actions pour automatiser les vérifications de qualité de code :

### Pipeline automatique (déclenché sur push/PR)

1. **Backend CI** :
   - Build de l'image Docker
   - Exécution des tests avec couverture de code
   - Vérification du formatage avec Prettier ❌ (bloquant)
   - Vérification du lint avec ESLint ❌ (bloquant)

2. **Frontend CI** :
   - Installation des dépendances
   - Vérification du formatage avec Prettier ❌ (bloquant)
   - Vérification du lint avec ESLint ❌ (bloquant)
   - Build du projet React
   - Build de l'image Docker

3. **Coverage Report** (uniquement sur master) :
   - Déploiement automatique du rapport de couverture sur GitHub Pages
   - 📊 **[Voir le rapport de couverture](https://sandrinecipolla.github.io/exo_confiance_en_soi/)**

### Commandes de développement

Avant de commiter, vous pouvez vérifier localement :

**Backend** :
```bash
cd m2-confiance-en-soi-docker/back
npm run lint          # Vérifier ESLint
npm run format:check  # Vérifier Prettier
npm run format        # Corriger automatiquement le formatage
```

**Frontend** :
```bash
cd m2-confiance-en-soi-docker/front/frontend
npm run lint          # Vérifier ESLint
npm run format:check  # Vérifier Prettier
npm run format        # Corriger automatiquement le formatage
```

**Tester le pipeline localement** (nécessite [act](https://github.com/nektos/act)) :
```bash
act push
```

---

## 🎯 URLs de l'application

### Docker Compose (Local)
- **Application complète** : http://localhost:3001
- **Backend uniquement** : http://localhost:8889
  - Route test : http://localhost:8889/
  - Affirmations FR : http://localhost:8889/affirmation/fr
  - Affirmations EN : http://localhost:8889/affirmation/en

### Kubernetes (Minikube)
- **Application complète** : http://127.0.0.1
- **Backend uniquement** : http://192.168.49.2:30888
  - Route test : http://192.168.49.2:30888/
  - Affirmations FR : http://192.168.49.2:30888/affirmation/fr
  - Affirmations EN : http://192.168.49.2:30888/affirmation/en

---

## ✨ Fonctionnalités

- ✅ Affichage d'affirmations positives en français et en anglais
- ✅ Changement automatique d'affirmation toutes les 5 secondes
- ✅ Interface utilisateur avec React et animations (Framer Motion)
- ✅ Backend Express avec base de données MariaDB
- ✅ Déploiement containerisé avec Docker
- ✅ Orchestration avec Kubernetes
- ✅ Proxy Vite pour éviter les problèmes CORS
- ✅ Hot Module Replacement (HMR) pour le développement

---

## 📚 Technologies utilisées

- **Frontend** : React 18, TypeScript, Vite 7, Framer Motion
- **Backend** : Node.js 20, Express.js, Sequelize ORM
- **Base de données** : MariaDB 11.8.3
- **Containerisation** : Docker, Docker Compose
- **Orchestration** : Kubernetes, Minikube
- **API externe** : https://www.affirmations.dev/ (affirmations en anglais)

---

## 👥 Auteur

Projet réalisé dans le cadre de la formation Ada Tech School - Module Docker & Kubernetes
