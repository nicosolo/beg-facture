import { createApp } from "vue"
import { createRouter, createWebHistory } from "vue-router"
import { createPinia } from "pinia"
import App from "./App.vue"
import HomeView from "./views/HomeView.vue"
import AboutView from "./views/AboutView.vue"

const routes = [
    { path: "/", component: HomeView },
    { path: "/about", component: AboutView },
]

const router = createRouter({
    history: createWebHistory(),
    routes,
})

const pinia = createPinia()
const app = createApp(App)

app.use(router)
app.use(pinia)
app.mount("#app")
