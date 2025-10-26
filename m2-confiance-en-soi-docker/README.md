# Confiance en Soi - Application de Citations Motivantes

Application web qui affiche des citations de confiance en soi en français et en anglais.

## 🚀 Application déployée sur Azure Kubernetes Service (AKS)

**URL publique :** http://20.216.193.148

### Architecture du déploiement

- **Frontend** : React + Vite (LoadBalancer public)
- **Backend** : Node.js + Express API (ClusterIP interne)
- **Base de données** : MariaDB avec PersistentVolume (1Gi)
- **Cluster** : AKS France Central (Kubernetes v1.32.7)
- **Namespace** : confiance-sandrine-v1

### Récupérer l'adresse IP publique

```bash
kubectl get service confiance-en-soi-front -n confiance-sandrine-v1
```

Ou uniquement l'IP :
```bash
kubectl get service confiance-en-soi-front -n confiance-sandrine-v1 -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

### Redéployer sur AKS

Pour redéployer l'application après des modifications :

```bash
# Windows
deploy_aks.bat

# Le script va :
# 1. Builder les images Docker (backend et frontend)
# 2. Pousser les images vers Docker Hub
# 3. Appliquer les configurations Kubernetes
# 4. Redémarrer les deployments
```

## 🛠️ Développement

### CI/CD avec GitHub Actions

Le projet utilise un workflow CI/CD automatisé qui s'exécute à chaque push ou pull request. Le pipeline vérifie :

**Stage 1 - Vérifications du code (en parallèle) :**
- 📦 Installation des dépendances (backend et frontend)
- 🔍 Vérification ESLint (qualité du code)
- 🎨 Vérification Prettier (formatage)
- 🏗️ Build du frontend React

**Stage 2 - Build Docker (si Stage 1 réussit) :**
- 🐳 Construction de l'image Docker backend
- 🐳 Construction de l'image Docker frontend

**Stage 3 - Résumé :**
- 📊 Rapport complet des résultats

#### Tester le workflow localement avec `act`

Vous pouvez tester le workflow CI/CD localement avant de pusher avec [act](https://github.com/nektos/act) :

```bash
# Prérequis : act installé (via Chocolatey, Homebrew, etc.)

# Lister les jobs du workflow
act -l

# Exécuter le workflow complet (simule un push)
act push

# Exécuter seulement le job frontend
act push -j frontend

# Exécuter seulement le job backend
act push -j backend
```

⚠️ **Note** : L'exécution avec `act` peut prendre plusieurs minutes car il télécharge les images Docker et installe toutes les dépendances.

### Modifier le code

