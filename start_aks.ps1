# =====================================================
# Script PowerShell pour démarrer le cluster AKS
# Usage: Clic droit → Exécuter avec PowerShell
# =====================================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   DEMARRAGE DU CLUSTER AZURE AKS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Vérification connexion Azure
Write-Host "[INFO] Verification de la connexion Azure..." -ForegroundColor Yellow
try {
    $account = az account show 2>$null | ConvertFrom-Json
    Write-Host "[OK] Compte Azure actif: $($account.name)" -ForegroundColor Green
} catch {
    Write-Host "[ERREUR] Vous n'êtes pas connecté à Azure." -ForegroundColor Red
    Write-Host "Veuillez vous connecter avec: az login" -ForegroundColor Red
    Write-Host ""
    Write-Host "Appuyez sur une touche pour fermer..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Write-Host ""
Write-Host "[1/4] Démarrage du cluster AKS 'confiance'..." -ForegroundColor Yellow
Write-Host "[INFO] Cela peut prendre 2-3 minutes..." -ForegroundColor Gray
Write-Host ""

az aks start --resource-group confiance-en-soi --name confiance

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[ERREUR] Echec du démarrage du cluster" -ForegroundColor Red
    Write-Host ""
    Write-Host "Appuyez sur une touche pour fermer..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Write-Host ""
Write-Host "[2/4] Configuration du contexte kubectl..." -ForegroundColor Yellow
az aks get-credentials --resource-group confiance-en-soi --name confiance --overwrite-existing

Write-Host ""
Write-Host "[3/4] Vérification de l'état des pods..." -ForegroundColor Yellow
Write-Host ""
kubectl get pods -n confiance-sandrine-v1

Write-Host ""
Write-Host "[4/4] Récupération de l'URL publique..." -ForegroundColor Yellow
$publicIP = kubectl get service confiance-en-soi-front -n confiance-sandrine-v1 -o jsonpath='{.status.loadBalancer.ingress[0].ip}'

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   CLUSTER DEMARRE AVEC SUCCES !" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "VOTRE APPLICATION EST ACCESSIBLE :" -ForegroundColor Cyan
Write-Host ""
Write-Host "    http://$publicIP" -ForegroundColor Yellow -BackgroundColor DarkBlue
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Commandes utiles :" -ForegroundColor Gray
Write-Host "  - Voir les pods : kubectl get pods -n confiance-sandrine-v1" -ForegroundColor Gray
Write-Host "  - Arrêter      : .\stop_aks.ps1" -ForegroundColor Gray
Write-Host ""
Write-Host "Appuyez sur une touche pour fermer..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
