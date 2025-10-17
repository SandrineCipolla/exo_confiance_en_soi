import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
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
    // strictPort: true,
    port: 3000, // Ensure this matches the exposed port in docker-compose.yml
    // hmr: {
    //   host: 'localhost', // Ensures Hot Module Replacement works when accessed via localhost
    // },
    proxy: {
      "/affirmation": {
        target: "http://backend:8888",
        changeOrigin: true,
        rewrite: (path) => path,
      },
    },
  },
})
