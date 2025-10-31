<template>
    <div class="w-full h-full rounded-lg overflow-hidden border border-gray-300">
        <div ref="mapContainer" class="w-full h-full"></div>
    </div>
</template>

<script setup lang="ts">
import { useGoogleMaps } from "@/composables/useGoogleMaps"
import { ref, onMounted, watch, onActivated } from "vue"

interface Props {
    latitude: number | null
    longitude: number | null
    zoom?: number
    height?: string
}

const props = withDefaults(defineProps<Props>(), {
    zoom: 14,
    height: "300px",
})

const mapContainer = ref<HTMLDivElement | null>(null)
let map: google.maps.Map | null = null
let marker: google.maps.marker.AdvancedMarkerElement | null = null

// Google Maps API key from environment variables
const MAP_ID = "BEG_PROJECT_DISPLAY_MAP"

const { loadGoogleMapsScript } = useGoogleMaps()

const initMap = async () => {
    if (!mapContainer.value) return
    if (props.latitude === null || props.longitude === null) return

    try {
        await loadGoogleMapsScript()

        const center = { lat: props.latitude, lng: props.longitude }

        map = new google.maps.Map(mapContainer.value, {
            center,
            zoom: props.zoom,
            mapTypeId: google.maps.MapTypeId.HYBRID,
            mapTypeControl: false,
            streetViewControl: false,
            fullscreenControl: false,
            zoomControl: true,
            mapId: MAP_ID,
        })

        // Add marker
        marker = new google.maps.marker.AdvancedMarkerElement({
            map,
            position: center,
        })
    } catch (error) {
        console.error("Error loading Google Maps:", error)
    }
}

const updateMarker = () => {
    // if (!map || props.latitude === null || props.longitude === null) return

    const position = { lat: props.latitude, lng: props.longitude }

    if (marker) {
        marker.position = position
    } else {
        marker = new google.maps.marker.AdvancedMarkerElement({
            map,
            position,
        })
    }

    map.setCenter(position)
}

onMounted(() => {
    initMap()
})

onActivated(() => {
    marker = null
    updateMarker()
})

watch([() => props.latitude, () => props.longitude], () => {
    if (map) {
        updateMarker()
    } else {
        initMap()
    }
})
</script>

<style scoped>
div {
    min-height: v-bind(height);
}
</style>
