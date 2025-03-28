import { createI18n } from "vue-i18n"
import fr from "./locales/fr"

export default createI18n({
    legacy: false, // Use Composition API mode
    globalInjection: true, // Make $t available in all components
    locale: "fr", // Set initial locale
    fallbackLocale: "fr", // Fallback locale
    messages: {
        fr,
    },
})
