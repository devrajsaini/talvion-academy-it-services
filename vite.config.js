import { resolve } from 'path';
import { defineConfig } from 'vite';

export default defineConfig({
  server: {
    port: 5173,
    host: true,
  },
  assetsInclude: ['**/*.download', '**/vt*', '**/vt(*)'],
  build: {
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'index.html'),
        home: resolve(__dirname, 'home.html'),
        about: resolve(__dirname, 'about.html'),
        courses: resolve(__dirname, 'courses.html'),
        roadmap: resolve(__dirname, 'roadmap.html'),
        contact: resolve(__dirname, 'contact.html'),
      },
    },
  },
});
