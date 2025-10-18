#!/bin/sh
echo "Creating .env file with environment variables..."
echo "VITE_API_URL=$VITE_API_URL" > /usr/src/app/.env
if [ -n "$VITE_PROXY_TARGET" ]; then
  echo "VITE_PROXY_TARGET=$VITE_PROXY_TARGET" >> /usr/src/app/.env
  echo "VITE_PROXY_TARGET is set to: $VITE_PROXY_TARGET"
fi
echo "Content of .env file:"
cat /usr/src/app/.env
echo "Clearing Vite cache..."
rm -rf /usr/src/app/node_modules/.vite
echo "Starting Vite dev server..."
exec npm run dev -- --host --port 3000
