# =====================================================
# Script PowerShell pour arrêter le cluster AKS
# Usage: Clic droit → Exécuter avec PowerShell
# =====================================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   ARRET DU CLUSTER AZURE AKS" -ForegroundColor Cyan
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
Write-Host "[INFO] Arrêt du cluster AKS 'confiance'..." -ForegroundColor Yellow
Write-Host "[INFO] Cela va arrêter toutes les VMs mais garder la configuration" -ForegroundColor Gray
Write-Host "[INFO] Coût pendant l'arrêt : ~0.02€/jour (seulement le stockage PVC)" -ForegroundColor Gray
Write-Host ""

az aks stop --resource-group confiance-en-soi --name confiance

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[ERREUR] Echec de l'arrêt du cluster" -ForegroundColor Red
    Write-Host ""
    Write-Host "Appuyez sur une touche pour fermer..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   CLUSTER ARRETE AVEC SUCCES !" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "[OK] Le cluster AKS est maintenant arrêté" -ForegroundColor Green
Write-Host "[OK] Vos données sont conservées dans le PersistentVolume" -ForegroundColor Green
Write-Host "[OK] La configuration est préservée" -ForegroundColor Green
Write-Host ""
Write-Host "Pour redémarrer le cluster:" -ForegroundColor Cyan
Write-Host "  Clic droit sur start_aks.ps1 → Exécuter avec PowerShell" -ForegroundColor Yellow
Write-Host ""
Write-Host "Temps de redémarrage : 2-3 minutes" -ForegroundColor Gray
Write-Host ""
Write-Host "Appuyez sur une touche pour fermer..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
