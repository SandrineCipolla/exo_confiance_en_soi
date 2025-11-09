# 🗑️ Suppression et Recréation du Cluster Azure AKS "confiance"

**Date de création** : 9 novembre 2025
**Projet** : Application "Confiance en soi" - Exercice Docker & Kubernetes
**Cluster Azure** : `confiance` (France Central)

---

## 📊 Contexte : Pourquoi Supprimer le Cluster ?

### 💰 Analyse des Coûts Azure

Le cluster Kubernetes Azure AKS "confiance" a été créé le **24 octobre 2025** pour l'exercice pédagogique.

#### Coûts mensuels du cluster :
```
Load Balancer                     :  3,80€/mois
Virtual Machine Standard_A2_v2    :  5-8€/mois
IP publiques (2x)                 :  1,32€/mois
Azure Monitor + Prometheus        :  2-5€/mois
Disque persistant (PVC)           :  0,11€/mois
───────────────────────────────────────────
TOTAL                             : ~15-20€/mois
```

**⚠️ IMPORTANT** : Même avec le cluster **arrêté** (stopped), certaines ressources continuent de coûter de l'argent :
- Load Balancer : **3,80€/mois**
- Azure Monitor + Prometheus : **~5€/mois**
- IPs publiques : **1,32€/mois**

**Coût mensuel cluster arrêté** : ~10€/mois

### 🎯 Décision de Suppression

Ce cluster a été créé **uniquement pour l'exercice pédagogique** de déploiement Kubernetes dans le cadre du Module 3 (Docker & Kubernetes) de la formation Ada Tech School.

**Raisons de la suppression** :
1. ✅ **Exercice terminé** - Le déploiement Azure AKS a été réalisé avec succès
2. ✅ **Coûts récurrents** - ~15-20€/mois pour un environnement de test
3. ✅ **Alternative locale disponible** - L'application fonctionne parfaitement avec Minikube (gratuit)
4. ✅ **Recréation facile** - Le cluster peut être recréé en ~10 minutes si nécessaire

**Économie attendue** : ~15-20€/mois

---

## 📋 Inventaire des Ressources du Cluster

### Cluster AKS Principal
- **Nom** : confiance
- **Resource Group** : confiance-en-soi
- **Localisation** : France Central
- **Version Kubernetes** : 1.32.7
- **Tier** : Free (control plane gratuit)
- **Node Pool** :
  - Nom : confiance
  - VM Size : Standard_A2_v2
  - Nodes : 1 (avec autoscaling 1-20)

### Ressources Associées (Resource Group : MC_confiance-en-soi_confiance_francecentral)
- **Disque persistant** : `pvc-07d0b157-2054-456e-89fd-1552b45a87a1`
  - Utilisé pour MariaDB
  - Contient les affirmations positives (FR + EN)
- **Load Balancer** : kubernetes
- **IP publiques** : 2 adresses
  - IP application : http://20.216.193.148
- **Virtual Network** : aks-vnet-66347050
- **Network Security Group** : aks-agentpool-66347050-nsg

### Ressources de Monitoring (Resource Group : MA_defaultazuremonitorworkspace-par_francecentral_managed)
- **Azure Monitor Workspace** : defaultazuremonitorworkspace-par
- **Data Collection Endpoints** : MSProm-francecentral-confiance
- **Prometheus Rule Groups** : 6 règles actives
- **Metric Alerts** :
  - Memory Working Set Percentage - confiance
  - CPU Usage Percentage - confiance

### Namespace Kubernetes
- **Namespace** : confiance-sandrine-v1
- **Pods** : 3 (frontend, backend, MariaDB)
- **Services** : 3 (ClusterIP backend, LoadBalancer frontend, ClusterIP MariaDB)
- **ConfigMaps** : 3 (backend, frontend, MariaDB init)
- **PersistentVolumeClaim** : 1 (mariadb-pvc, 1Gi)

---

## ✅ Tout est Déjà Sauvegardé ! (Pas Besoin de Backup Supplémentaire)

### 🎉 Bonne Nouvelle

**Vous n'avez PAS besoin de sauvegarder le cluster avant suppression !**

Toutes les configurations et données importantes sont **déjà dans votre code source Git** :

### 📁 Configurations Kubernetes (Dossier `m2-confiance-en-soi-docker/k8s-aks/`)

Toutes les configurations Kubernetes sont versionnées dans Git :

- ✅ **01-namespace.yaml** - Namespace `confiance-sandrine-v1`
- ✅ **02-back-configmap.yaml** - Configuration backend
- ✅ **03-front-configmap.yaml** - Configuration frontend
- ✅ **03.5-mariadb-initdb-configmap.yaml** - Script SQL d'initialisation MariaDB (contient toutes les affirmations FR + EN)
- ✅ **03.6-mariadb-pvc.yaml** - PersistentVolumeClaim (1Gi)
- ✅ **04-mariadb.yaml** - Deployment MariaDB
- ✅ **05-deployment_backend.yaml** - Deployment backend Node.js
- ✅ **06-deployment_frontend.yaml** - Deployment frontend React
- ✅ **07-service_backend.yaml** - Service backend (ClusterIP)
- ✅ **08-service_frontend.yaml** - Service frontend (LoadBalancer avec IP publique)

### 💾 Données MariaDB

- ✅ **Toutes les affirmations positives** (français + anglais) sont dans le fichier `m2-confiance-en-soi-docker/back/init.sql`
- ✅ Ce script est monté automatiquement via ConfigMap lors du déploiement
- ✅ Les données sont recréées à chaque nouveau déploiement

### 🐳 Images Docker

- ✅ Images backend et frontend disponibles sur **Docker Hub**
- ✅ Référencées dans les fichiers de déploiement Kubernetes

### 📝 Scripts d'Automatisation

- ✅ **deploy_aks.bat** - Script de déploiement automatique sur Azure
- ✅ **start_aks.ps1** / **start_aks.bat** - Scripts de démarrage du cluster
- ✅ **stop_aks.ps1** / **stop_aks.bat** - Scripts d'arrêt du cluster

### 🎯 Conclusion

**Vous pouvez supprimer le cluster en toute confiance !**

Tout ce qui est nécessaire pour recréer l'exercice est :
1. ✅ Dans votre dépôt Git local
2. ✅ Sur Docker Hub (images)
3. ✅ Documenté dans le README.md

**Aucun backup supplémentaire n'est nécessaire.**

---

## 🔄 Refaire l'Exercice Plus Tard (Guide Complet)

Si vous devez refaire l'exercice Azure AKS dans le futur (pour une démo, un portfolio, ou réviser), voici les étapes **simples** :

### 📋 Prérequis

- ✅ Azure CLI installé et configuré (`az login`)
- ✅ kubectl installé
- ✅ Docker Hub compte (pour les images)
- ✅ Ce dépôt Git cloné localement

### 🚀 Étapes pour Refaire l'Exercice

#### 1️⃣ Créer le Cluster AKS (~5 minutes)

```bash
# Se placer dans le dossier du projet
cd "C:/Users/sandr/Dev/Ada/M3/module Docker/exo_confiance_en_soi"

# Créer le resource group
az group create --name confiance-en-soi --location francecentral

# Créer le cluster AKS (config minimale, tier gratuit)
az aks create \
  --resource-group confiance-en-soi \
  --name confiance \
  --node-count 1 \
  --node-vm-size Standard_B2s \
  --enable-managed-identity \
  --generate-ssh-keys \
  --tier free \
  --location francecentral
```

**Durée** : ~5-10 minutes
**Coût** : ~15-20€/mois

#### 2️⃣ Récupérer les Credentials Kubernetes

```bash
# Se connecter au cluster
az aks get-credentials --resource-group confiance-en-soi --name confiance --overwrite-existing

# Vérifier la connexion
kubectl get nodes
```

#### 3️⃣ Déployer l'Application (~2 minutes)

**Option A - Via le script automatique** (recommandé) :
```bash
# Depuis le dossier du projet
deploy_aks.bat
```

Le script va automatiquement :
- ✅ Builder les images Docker (backend + frontend)
- ✅ Pousser les images sur Docker Hub
- ✅ Appliquer toutes les configurations Kubernetes (dossier `k8s-aks/`)
- ✅ Créer le namespace, les ConfigMaps, les PVC
- ✅ Déployer MariaDB, backend, frontend
- ✅ Créer le LoadBalancer avec IP publique

**Option B - Déploiement manuel** :
```bash
cd m2-confiance-en-soi-docker

# Appliquer toutes les configurations dans l'ordre
kubectl apply -f k8s-aks/01-namespace.yaml
kubectl apply -f k8s-aks/02-back-configmap.yaml
kubectl apply -f k8s-aks/03-front-configmap.yaml
kubectl apply -f k8s-aks/03.5-mariadb-initdb-configmap.yaml
kubectl apply -f k8s-aks/03.6-mariadb-pvc.yaml
kubectl apply -f k8s-aks/04-mariadb.yaml
kubectl apply -f k8s-aks/05-deployment_backend.yaml
kubectl apply -f k8s-aks/06-deployment_frontend.yaml
kubectl apply -f k8s-aks/07-service_backend.yaml
kubectl apply -f k8s-aks/08-service_frontend.yaml
```

#### 4️⃣ Récupérer l'URL Publique (~2-3 minutes pour l'IP)

```bash
# Attendre que l'IP publique soit assignée
kubectl get service confiance-en-soi-front -n confiance-sandrine-v1 --watch

# Récupérer l'IP publique (CTRL+C pour quitter le watch)
kubectl get service confiance-en-soi-front -n confiance-sandrine-v1 -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

**L'application sera accessible sur** : `http://<NOUVELLE-IP-PUBLIQUE>`

**Note** : L'IP sera différente de l'ancienne (20.216.193.148)

#### 5️⃣ Vérifier que Tout Fonctionne

```bash
# Vérifier les pods
kubectl get pods -n confiance-sandrine-v1

# Vérifier les services
kubectl get services -n confiance-sandrine-v1

# Voir les logs du backend
kubectl logs -l app=confiance-en-soi-back -n confiance-sandrine-v1 --tail=30

# Voir les logs du frontend
kubectl logs -l app=confiance-en-soi-front -n confiance-sandrine-v1 --tail=30
```

#### 6️⃣ Après la Démo : Arrêter ou Supprimer

**Arrêter le cluster** (pour économiser mais garder les configs) :
```bash
# Méthode 1 : Via le script PowerShell
.\stop_aks.ps1

# Méthode 2 : Via Azure CLI
az aks stop --resource-group confiance-en-soi --name confiance
```

**Supprimer complètement** (économie maximale) :
```bash
az group delete --name confiance-en-soi --yes
az group delete --name MC_confiance-en-soi_confiance_francecentral --yes
az group delete --name MA_defaultazuremonitorworkspace-par_francecentral_managed --yes
```

### 🎓 Résumé pour Refaire l'Exercice

| Étape | Commande | Durée |
|-------|----------|-------|
| 1. Créer cluster | `az aks create ...` | 5-10 min |
| 2. Credentials | `az aks get-credentials ...` | 10 sec |
| 3. Déployer app | `deploy_aks.bat` | 2-5 min |
| 4. Récupérer IP | `kubectl get service ...` | 2-3 min |
| **TOTAL** | | **~10-20 min** |

**Coût** : ~15-20€/mois tant que le cluster existe

### 💡 Conseil Pro

Utilisez **Minikube** (gratuit) pour l'apprentissage et les tests :
```bash
minikube start
cd m2-confiance-en-soi-docker
redeploy_k8s.bat
# Application sur http://127.0.0.1
```

Utilisez **Azure AKS** seulement quand vous avez besoin :
- D'une URL publique pour une démo
- De montrer votre portfolio
- De tester en conditions réelles (production-like)

---

## 💾 Sauvegarde Supplémentaire (Optionnel - Si Vous Avez Modifié des Données)

### Si Vous Avez Ajouté des Affirmations Personnalisées

**IMPORTANT** : Cette section est nécessaire SEULEMENT si vous avez modifié les données dans la base MariaDB après le déploiement initial.

```bash
# Se placer dans le dossier du projet
cd "C:/Users/sandr/Dev/Ada/M3/module Docker/exo_confiance_en_soi"

# Se connecter au cluster Azure
az aks get-credentials --resource-group confiance-en-soi --name confiance

# Créer un dossier de backup
mkdir -p backups

# Sauvegarder toutes les ressources du namespace
kubectl get all -n confiance-sandrine-v1 -o yaml > backups/azure-aks-backup-all.yaml

# Sauvegarder les ConfigMaps
kubectl get configmaps -n confiance-sandrine-v1 -o yaml > backups/azure-aks-backup-configmaps.yaml

# Sauvegarder les PVC (volumes persistants)
kubectl get pvc -n confiance-sandrine-v1 -o yaml > backups/azure-aks-backup-pvc.yaml

# Sauvegarder les secrets (si vous en avez)
kubectl get secrets -n confiance-sandrine-v1 -o yaml > backups/azure-aks-backup-secrets.yaml
```

### Étape 2 : Sauvegarder les Données MariaDB

**Option A - Via kubectl exec (RECOMMANDÉ)** :
```bash
# Se connecter au pod MariaDB et faire un dump
kubectl exec -n confiance-sandrine-v1 deployment/confiance-en-soi-db -- \
  mysqldump -uroot -proot_password confiance_db > backups/mariadb-backup.sql
```

**Option B - Les données sont déjà dans le code source** :
Les affirmations positives sont initialisées via le fichier `back/init.sql`, donc aucune sauvegarde supplémentaire n'est nécessaire si vous n'avez pas modifié les données.

### ✅ Vérification des Sauvegardes

```bash
# Vérifier que les fichiers ont été créés
ls -lh backups/

# Devrait contenir :
# - azure-aks-backup-all.yaml
# - azure-aks-backup-configmaps.yaml
# - azure-aks-backup-pvc.yaml
# - azure-aks-backup-secrets.yaml
# - mariadb-backup.sql (optionnel)
```

---

## 🗑️ Suppression du Cluster

### ⚠️ ATTENTION : Actions Irréversibles

Une fois le cluster supprimé :
- ❌ **Toutes les données** stockées dans les volumes persistants (PVC) seront perdues
- ❌ **Toutes les configurations** Kubernetes seront perdues
- ❌ **L'URL publique** http://20.216.193.148 ne sera plus accessible
- ❌ **Les certificats et secrets** seront perdus

Mais ne vous inquiétez pas :
- ✅ Les **configurations YAML** sont dans le dossier `k8s-aks/`
- ✅ Les **images Docker** sont sur Docker Hub
- ✅ Le **code source** est dans Git
- ✅ Les **sauvegardes** sont dans le dossier `backups/`

### Méthode 1 : Suppression Complète (RECOMMANDÉ)

**Supprime le cluster ET toutes ses ressources associées** :

```bash
# Supprimer le groupe de ressources principal
az group delete --name confiance-en-soi --yes

# Supprimer le groupe de ressources managé (créé automatiquement par AKS)
az group delete --name MC_confiance-en-soi_confiance_francecentral --yes

# Supprimer le groupe de monitoring (créé automatiquement par Azure Monitor)
az group delete --name MA_defaultazuremonitorworkspace-par_francecentral_managed --yes
```

**Durée** : 5-10 minutes
**Coût après suppression** : 0€

### Méthode 2 : Suppression du Cluster Uniquement

**Supprime seulement le cluster AKS, garde le resource group** :

```bash
# Supprimer uniquement le cluster
az aks delete --resource-group confiance-en-soi --name confiance --yes
```

**Note** : Vous devrez supprimer manuellement les autres ressources (Load Balancer, IPs, etc.)

### Méthode 3 : Via le Portail Azure (Interface Graphique)

1. Allez sur https://portal.azure.com
2. Dans la barre de recherche, tapez : `confiance-en-soi`
3. Cliquez sur le **Resource Group** `confiance-en-soi`
4. Cliquez sur **"Delete resource group"** en haut
5. Tapez le nom du groupe : `confiance-en-soi`
6. Cliquez sur **"Delete"**

**Répétez pour les 2 autres groupes** :
- `MC_confiance-en-soi_confiance_francecentral`
- `MA_defaultazuremonitorworkspace-par_francecentral_managed`

---

## 🔄 Recréation du Cluster (Si Nécessaire Plus Tard)

Si vous avez besoin de redéployer l'application sur Azure plus tard (pour une démo, un portfolio, etc.), voici comment faire :

### Étape 1 : Recréer le Cluster AKS

```bash
# Créer le resource group
az group create --name confiance-en-soi --location francecentral

# Créer le cluster AKS (configuration minimale)
az aks create \
  --resource-group confiance-en-soi \
  --name confiance \
  --node-count 1 \
  --node-vm-size Standard_B2s \
  --enable-managed-identity \
  --generate-ssh-keys \
  --tier free \
  --location francecentral
```

**Durée** : ~5-10 minutes
**Coût estimé** : ~15-20€/mois

### Étape 2 : Récupérer les Credentials

```bash
# Récupérer les credentials kubectl
az aks get-credentials --resource-group confiance-en-soi --name confiance --overwrite-existing
```

### Étape 3 : Redéployer l'Application

**Option A - Utiliser les fichiers k8s-aks/ existants** :
```bash
# Appliquer toutes les configurations
kubectl apply -f k8s-aks/

# Vérifier le déploiement
kubectl get pods -n confiance-sandrine-v1
kubectl get services -n confiance-sandrine-v1
```

**Option B - Utiliser le script de déploiement automatique** :
```bash
deploy_aks.bat
```

### Étape 4 : Récupérer la Nouvelle URL

```bash
# Attendre que l'IP publique soit assignée (2-3 minutes)
kubectl get service confiance-en-soi-front -n confiance-sandrine-v1 --watch

# Récupérer l'IP publique
kubectl get service confiance-en-soi-front -n confiance-sandrine-v1 -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

**Note** : L'IP publique sera **différente** de l'ancienne (20.216.193.148).

### Étape 5 : Restaurer les Données (Si Nécessaire)

Si vous aviez sauvegardé des données MariaDB personnalisées :

```bash
# Copier le dump SQL dans le pod MariaDB
kubectl cp backups/mariadb-backup.sql confiance-sandrine-v1/confiance-en-soi-db-xxxxxxx:/tmp/backup.sql

# Se connecter au pod et restaurer
kubectl exec -n confiance-sandrine-v1 deployment/confiance-en-soi-db -it -- bash
mysql -uroot -proot_password confiance_db < /tmp/backup.sql
exit
```

---

## 🎯 Alternative Gratuite : Utiliser Minikube (Local)

Au lieu de dépenser 15-20€/mois pour un cluster Azure, vous pouvez utiliser **Minikube** gratuitement en local :

### Avantages de Minikube
- ✅ **Gratuit** - 0€/mois
- ✅ **Local** - Pas besoin de connexion Internet
- ✅ **Rapide** - Démarrage en ~30 secondes
- ✅ **Identique** - Même expérience Kubernetes qu'Azure

### Inconvénients de Minikube
- ❌ **Non accessible publiquement** - Seulement en localhost
- ❌ **Dépend de votre machine** - Nécessite que votre PC soit allumé
- ❌ **Pas de haute disponibilité** - Un seul nœud

### Comment Utiliser Minikube

```bash
# Démarrer Minikube (une seule fois après installation)
minikube start

# Déployer l'application
redeploy_k8s.bat

# Accéder à l'application
# Frontend : http://127.0.0.1
# Backend : http://192.168.49.2:30888
```

**Recommandation** : Utilisez Minikube pour le développement et les tests. Utilisez Azure AKS uniquement si vous avez besoin d'une URL publique pour une démo ou un portfolio.

---

## 📊 Comparaison des Options

| Critère | Azure AKS | Minikube Local | Docker Compose |
|---------|-----------|----------------|----------------|
| **Coût** | ~15-20€/mois | Gratuit | Gratuit |
| **Accès public** | ✅ Oui (IP publique) | ❌ Non (localhost) | ❌ Non (localhost) |
| **Démarrage** | 2-3 min (si arrêté) | ~30 sec | ~10 sec |
| **Haute disponibilité** | ✅ Possible | ❌ Non | ❌ Non |
| **Expérience K8s** | ✅ Production-like | ✅ Identique | ❌ Non (pas K8s) |
| **Complexité** | 🔴 Haute | 🟡 Moyenne | 🟢 Faible |
| **Recommandé pour** | Démo publique, portfolio | Apprentissage K8s, tests | Développement quotidien |

---

## 🚀 Workflow Recommandé

### Pour le Développement Quotidien
```bash
docker compose up -d
# Application disponible sur http://localhost:3001
```

### Pour Apprendre Kubernetes
```bash
minikube start
redeploy_k8s.bat
# Application disponible sur http://127.0.0.1
```

### Pour une Démo Publique ou Portfolio
```bash
# Recréer le cluster Azure (voir section "Recréation du Cluster")
az aks create ...
deploy_aks.bat
# Application disponible sur http://<IP-PUBLIQUE-AZURE>
```

### Après la Démo
```bash
# Arrêter le cluster pour économiser
az aks stop --resource-group confiance-en-soi --name confiance

# OU supprimer complètement si pas besoin pendant plusieurs mois
az group delete --name confiance-en-soi --yes
```

---

## 📝 Checklist de Suppression

Avant de supprimer le cluster, vérifiez que :

- [ ] J'ai sauvegardé les configurations Kubernetes (`kubectl get all -o yaml`)
- [ ] J'ai sauvegardé les données MariaDB si nécessaires
- [ ] J'ai noté l'URL publique actuelle (pour documentation)
- [ ] J'ai mis à jour le README.md pour indiquer que le cluster est supprimé
- [ ] J'ai testé que Minikube fonctionne correctement en local
- [ ] Je n'ai plus besoin de l'URL publique Azure

Puis exécuter :
```bash
az group delete --name confiance-en-soi --yes
az group delete --name MC_confiance-en-soi_confiance_francecentral --yes
az group delete --name MA_defaultazuremonitorworkspace-par_francecentral_managed --yes
```

---

## 📞 Support et Questions

### Problèmes Courants

**Q : Je ne peux plus accéder à l'application après suppression**
**R** : Normal ! Le cluster et l'IP publique ont été supprimés. Utilisez Minikube en local ou recréez le cluster Azure.

**Q : Combien de temps pour recréer le cluster ?**
**R** : ~10 minutes (5 min création + 5 min déploiement)

**Q : L'IP publique sera-t-elle la même ?**
**R** : Non, Azure assignera une nouvelle IP publique aléatoire.

**Q : Puis-je récupérer mes données après suppression ?**
**R** : Seulement si vous avez fait un backup avant. Sinon, les données sont perdues définitivement.

**Q : Combien vais-je économiser ?**
**R** : ~15-20€/mois (soit ~180-240€/an)

---

## 📅 Historique

- **24 octobre 2025** : Création du cluster AKS "confiance" pour l'exercice pédagogique
- **26 octobre 2025** : Déploiement réussi de l'application (http://20.216.193.148)
- **9 novembre 2025** : Décision de suppression pour optimisation des coûts Azure
- **9 novembre 2025** : Documentation créée (ce fichier)

---

## 🎓 Conclusion

Le cluster Azure AKS "confiance" a rempli son objectif pédagogique :
- ✅ Apprentissage du déploiement Kubernetes en production
- ✅ Gestion des ressources Azure
- ✅ Configuration Load Balancer, PVC, monitoring
- ✅ Scripts d'automatisation (start/stop/deploy)

**Maintenant que l'exercice est terminé**, il est recommandé de :
1. **Supprimer le cluster** pour économiser ~15-20€/mois
2. **Utiliser Minikube** pour continuer à apprendre Kubernetes gratuitement
3. **Recréer le cluster Azure** seulement si besoin d'une démo publique

**Économie annuelle estimée** : ~200€/an

---

**Auteur** : Sandrine Cipolla
**Formation** : Ada Tech School - Module 3 (Docker & Kubernetes)
**Date** : 9 novembre 2025
