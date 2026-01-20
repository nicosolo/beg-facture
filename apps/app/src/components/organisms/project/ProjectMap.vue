<template>
    <div class="w-full h-full rounded-lg shadow-lg overflow-hidden">
        <div ref="mapContainer" class="w-full h-full"></div>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, onActivated, watch } from "vue"
import { MarkerClusterer } from "@googlemaps/markerclusterer"
import type { ProjectMapItemResponse } from "@beg/validations"
import { useRouter } from "vue-router"
import { buildGoogleMapsUrl, buildGeoAdminUrl } from "@/utils/coordinates"
import { useGoogleMaps } from "@/composables/useGoogleMaps"

export interface MapBounds {
    minLat: number
    maxLat: number
    minLng: number
    maxLng: number
}

interface Props {
    projects: ProjectMapItemResponse[]
}

const props = defineProps<Props>()
const emit = defineEmits<{
    boundsChanged: [bounds: MapBounds]
}>()
const mapContainer = ref<HTMLDivElement | null>(null)
const router = useRouter()

const { loadGoogleMapsScript } = useGoogleMaps()

let map: google.maps.Map | null = null
let markerClusterer: MarkerClusterer | null = null
const markers: google.maps.marker.AdvancedMarkerElement[] = []
let boundsChangeTimeout: ReturnType<typeof setTimeout> | null = null
let isInitialLoad = true
let skipNextBoundsEmit = false
let currentInfoWindow: google.maps.InfoWindow | null = null
let openProjectId: number | null = null
const markerInfoWindows = new Map<number, { marker: google.maps.marker.AdvancedMarkerElement; infoWindow: google.maps.InfoWindow }>()

// Switzerland default center
const SWITZERLAND_CENTER = { lat: 46.8, lng: 8.2 }

// Emit bounds with debounce

const debouncedEmitBounds = () => {
    if (!map) return
    if (skipNextBoundsEmit) {
        skipNextBoundsEmit = false
        return
    }

    const bounds = map.getBounds()
    if (!bounds) return

    const ne = bounds.getNorthEast()
    const sw = bounds.getSouthWest()

    emit("boundsChanged", {
        minLat: sw.lat(),
        maxLat: ne.lat(),
        minLng: sw.lng(),
        maxLng: ne.lng(),
    })
}

// Unique Map ID for advanced markers (required)
const MAP_ID = "BEG_PROJECTS_MAP"

const initMap = async () => {
    if (!mapContainer.value) return

    try {
        // Load Google Maps script
        await loadGoogleMapsScript()

        // Create the map with mapId required for AdvancedMarkerElement
        // Using HYBRID instead of SATELLITE to show labels on satellite imagery
        map = new google.maps.Map(mapContainer.value, {
            center: SWITZERLAND_CENTER,
            zoom: 8,
            mapTypeId: google.maps.MapTypeId.HYBRID, // Satellite view with place names/labels
            mapTypeControl: true,
            streetViewControl: false,
            fullscreenControl: true,
            mapId: MAP_ID, // Required for AdvancedMarkerElement
            tilt: 0, // Disable 45-degree aerial view
        })

        // Listen for bounds changes (pan/zoom) to filter by viewport
        map.addListener("idle", debouncedEmitBounds)

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
    markerInfoWindows.clear()

    if (markerClusterer) {
        markerClusterer.clearMarkers()
    }

    // Close current info window before recreating
    if (currentInfoWindow) {
        currentInfoWindow.close()
        currentInfoWindow = null
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

        // Track info window close
        infoWindow.addListener("closeclick", () => {
            currentInfoWindow = null
            openProjectId = null
        })

        marker.addListener("click", () => {
            // Close any existing info window
            if (currentInfoWindow) {
                currentInfoWindow.close()
            }
            currentInfoWindow = infoWindow
            openProjectId = project.id
            infoWindow.open(map!, marker)
        })

        // Store for potential reopening after reload
        markerInfoWindows.set(project.id, { marker, infoWindow })
        markers.push(marker)
    }

    // Reopen info window if one was open before reload
    if (openProjectId !== null) {
        const entry = markerInfoWindows.get(openProjectId)
        if (entry) {
            currentInfoWindow = entry.infoWindow
            entry.infoWindow.open(map!, entry.marker)
        } else {
            // Project no longer in view, clear the tracking
            openProjectId = null
        }
    }

    // Add marker clustering with consistent indigo color
    if (markers.length > 0) {
        markerClusterer = new MarkerClusterer({
            map,
            markers,
        })

        // Only fit bounds on initial load to avoid loop when updating from bounds filter
        if (isInitialLoad) {
            isInitialLoad = false
            skipNextBoundsEmit = true

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

// Handle component reactivation when using KeepAlive
onActivated(() => {
    // Re-create markers when component is reactivated from cache
    if (map && props.projects.length > 0) {
        createMarkers()
    }
})

// Re-create markers when projects change
watch(() => props.projects, createMarkers, { deep: true })

// Cleanup
onUnmounted(() => {
    window.removeEventListener("navigate-to-project", handleNavigateToProject)
    if (boundsChangeTimeout) {
        clearTimeout(boundsChangeTimeout)
    }
    if (markerClusterer) {
        markerClusterer.clearMarkers()
    }
})
</script>
