
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

