@echo off
echo Demarrage des services Docker...
cd /d "C:\Users\sandr\Dev\Ada\M3\module Docker\exo_confiance_en_soi\m2-confiance-en-soi-docker"
docker-compose down
docker-compose up -d
echo Services demarres!
pause

