import { fileURLToPath, URL } from "node:url"

import { defineConfig } from "vite"
import vue from "@vitejs/plugin-vue"
import vueDevTools from "vite-plugin-vue-devtools"
import tailwindcss from "@tailwindcss/vite"

export default defineConfig({
    plugins: [vue(), vueDevTools(), tailwindcss()],
    server: {
        port: 8080,
        host: true,
        hmr: {
            host: process.env.VITE_HMR_HOST || "localhost",
            port: parseInt(process.env.VITE_HMR_PORT || "8080"),
            clientPort: 8084, // The port exposed by your proxy
        },
        watch: {
            useFsEvents: true,
        },
    },
    resolve: {
        alias: {
            "@": fileURLToPath(new URL("./src", import.meta.url)),
        },
    },
})
