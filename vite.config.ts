/// <reference types="vitest" />
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  build: {
    commonjsOptions: {
      transformMixedEsModules: true,
    },
  },
  test: {
    environment: "jsdom",
    coverage: {
      reporter: ["text", "json", "json-summary"],
        lines: 95,
        branches: 95,
        functions: 100,
        statements: 95
    },
    setupFiles: ["./test/setup.ts"],
  },
});
