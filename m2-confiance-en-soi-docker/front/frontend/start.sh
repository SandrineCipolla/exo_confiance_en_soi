#!/bin/sh
echo "Creating .env file with VITE_API_URL=$VITE_API_URL"
echo "VITE_API_URL=$VITE_API_URL" > /usr/src/app/.env
cat /usr/src/app/.env
echo "Clearing Vite cache..."
rm -rf /usr/src/app/node_modules/.vite
echo "Starting Vite dev server..."
exec npm run dev -- --host --port 3000
