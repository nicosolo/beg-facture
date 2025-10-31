<template>
    <div class="w-full h-full rounded-lg shadow-lg overflow-hidden">
        <div ref="mapContainer" class="w-full h-full"></div>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from "vue"
import { MarkerClusterer } from "@googlemaps/markerclusterer"
import type { ProjectMapItemResponse } from "@beg/validations"
import { useRouter } from "vue-router"
import { buildGoogleMapsUrl, buildGeoAdminUrl } from "@/utils/coordinates"

interface Props {
    projects: ProjectMapItemResponse[]
}

const props = defineProps<Props>()
const mapContainer = ref<HTMLDivElement | null>(null)
const router = useRouter()

let map: google.maps.Map | null = null
let markerClusterer: MarkerClusterer | null = null
const markers: google.maps.marker.AdvancedMarkerElement[] = []

// Google Maps API key - you may want to move this to environment variables
const GOOGLE_MAPS_API_KEY = "AIzaSyCKYod6aTgm5V_ezwwM-F9a15GVoFJmVR8"

// Switzerland default center
const SWITZERLAND_CENTER = { lat: 46.8, lng: 8.2 }

// Unique Map ID for advanced markers (required)
const MAP_ID = "BEG_PROJECTS_MAP"

const loadGoogleMapsScript = (): Promise<void> => {
    return new Promise((resolve, reject) => {
        if (typeof google !== "undefined" && google.maps) {
            resolve()
            return
        }

        const script = document.createElement("script")
        script.src = `https://maps.googleapis.com/maps/api/js?key=${GOOGLE_MAPS_API_KEY}&libraries=marker`
        script.async = true
        script.defer = true
        script.onload = () => resolve()
        script.onerror = () => reject(new Error("Failed to load Google Maps script"))
        document.head.appendChild(script)
    })
}

const initMap = async () => {
    if (!mapContainer.value) return

    try {
        // Load Google Maps script
        await loadGoogleMapsScript()

        // Create the map with mapId required for AdvancedMarkerElement
        map = new google.maps.Map(mapContainer.value, {
            center: SWITZERLAND_CENTER,
            zoom: 8,
            mapTypeId: google.maps.MapTypeId.SATELLITE,
            mapTypeControl: true,
            streetViewControl: false,
            fullscreenControl: true,
            mapId: MAP_ID, // Required for AdvancedMarkerElement
        })

        // Add markers for projects
        createMarkers()
    } catch (error) {
        console.error("Error loading Google Maps:", error)
    }
}

const createMarkers = async () => {
    if (!map) return

    // Clear existing markers
    markers.forEach((marker) => {
        marker.map = null
    })
    markers.length = 0

    if (markerClusterer) {
        markerClusterer.clearMarkers()
    }

    // Create markers for each project using AdvancedMarkerElement
    for (const project of props.projects) {
        const marker = new google.maps.marker.AdvancedMarkerElement({
            map,
            position: {
                lat: project.latitude,
                lng: project.longitude,
            },
            title: `${project.projectNumber} - ${project.name}`,
        })

        // Generate map URLs
        const googleMapsUrl = buildGoogleMapsUrl(project.longitude, project.latitude)
        const geoAdminUrl = buildGeoAdminUrl(project.longitude, project.latitude)

        // Button styles matching standard buttons
        const buttonClass =
            "rounded-md font-medium focus:outline-none focus:ring-2 cursor-pointer leading-none block text-center bg-indigo-600 hover:bg-indigo-700 text-white text-sm px-3 py-1.5"

        // Create info window content
        const infoWindowContent = `
            <div class="p-3 max-w-xs">
                <h3 class="font-bold text-base mb-3">${project.projectNumber} - ${project.name}</h3>
                <div class="flex flex-col gap-2">
                    <button
                        onclick="window.dispatchEvent(new CustomEvent('navigate-to-project', { detail: ${project.id} }))"
                        class="${buttonClass}"
                    >
                        Voir le mandat
                    </button>
                    ${
                        googleMapsUrl
                            ? `<a
                        href="${googleMapsUrl}"
                        target="_blank"
                        rel="noopener noreferrer"
                        class="${buttonClass}"
                    >
                        Ouvrir dans Google Maps
                    </a>`
                            : ""
                    }
                    ${
                        geoAdminUrl
                            ? `<a
                        href="${geoAdminUrl}"
                        target="_blank"
                        rel="noopener noreferrer"
                        class="${buttonClass}"
                    >
                        Ouvrir dans Geo Admin
                    </a>`
                            : ""
                    }
                </div>
            </div>
        `

        const infoWindow = new google.maps.InfoWindow({
            content: infoWindowContent,
        })

        marker.addListener("click", () => {
            infoWindow.open(map!, marker)
        })

        markers.push(marker)
    }

    // Add marker clustering with consistent indigo color
    if (markers.length > 0) {
        markerClusterer = new MarkerClusterer({
            map,
            markers,
        })

        // Fit bounds to show all markers
        const bounds = new google.maps.LatLngBounds()
        props.projects.forEach((project) => {
            bounds.extend({ lat: project.latitude, lng: project.longitude })
        })
        map.fitBounds(bounds)

        // Ensure minimum zoom level
        const listener = google.maps.event.addListener(map, "idle", () => {
            if (map!.getZoom()! > 15) map!.setZoom(15)
            google.maps.event.removeListener(listener)
        })
    }
}

// Listen for navigation events from info windows
const handleNavigateToProject = (event: Event) => {
    const customEvent = event as CustomEvent<number>
    router.push({ name: "project-view", params: { id: customEvent.detail } })
}

onMounted(() => {
    initMap()
    window.addEventListener("navigate-to-project", handleNavigateToProject)
})

// Re-create markers when projects change
watch(() => props.projects, createMarkers, { deep: true })

// Cleanup
onMounted(() => {
    return () => {
        window.removeEventListener("navigate-to-project", handleNavigateToProject)
        if (markerClusterer) {
            markerClusterer.clearMarkers()
        }
    }
})
</script>
