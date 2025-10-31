import { ref } from "vue"

const isScriptLoaded = ref(false)
const isScriptLoading = ref(false)

export const useGoogleMaps = () => {
    const loadGoogleMapsScript = (): Promise<void> => {
        return new Promise((resolve, reject) => {
            // If already loaded, resolve immediately
            if (typeof google !== "undefined" && google.maps) {
                isScriptLoaded.value = true
                resolve()
                return
            }

            // If currently loading, wait for it to finish
            if (isScriptLoading.value) {
                const checkInterval = setInterval(() => {
                    if (isScriptLoaded.value) {
                        clearInterval(checkInterval)
                        resolve()
                    }
                }, 100)
                return
            }

            // Start loading the script
            isScriptLoading.value = true

            const script = document.createElement("script")
            script.src = `https://maps.googleapis.com/maps/api/js?key=${import.meta.env.VITE_GOOGLE_MAPS_API_KEY}&libraries=marker`
            script.async = true
            script.defer = true
            script.onload = () => {
                isScriptLoaded.value = true
                isScriptLoading.value = false
                resolve()
            }
            script.onerror = () => {
                isScriptLoading.value = false
                reject(new Error("Failed to load Google Maps script"))
            }
            document.head.appendChild(script)
        })
    }

    return {
        loadGoogleMapsScript,
        isScriptLoaded,
        isScriptLoading,
    }
}
