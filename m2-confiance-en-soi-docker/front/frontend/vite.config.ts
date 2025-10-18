import { defineConfig, loadEnv } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '')

  return {
    plugins: [
      react({
        babel: {
          plugins: [['babel-plugin-react-compiler']],
        },
      }),
    ],
    server: {
      host: '0.0.0.0', // Listen on all network interfaces (required for Docker) "--"
      watch: {
        usePolling: true, // Ensures file changes are detected inside Docker
      },
      strictPort: true,
      port: 3000, // Ensure this matches the exposed port in docker-compose.yml
      hmr: {
        clientPort: 3000, // Configure HMR to work with Docker
      },
      proxy: {
        "/affirmation": {
          target: env.VITE_PROXY_TARGET || "http://backend:8888",
          changeOrigin: true,
          rewrite: (path) => path,
        },
      },
    },
  }
})
