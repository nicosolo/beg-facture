<template>
    <div class="space-y-4">
        <!-- Coordinate Input Type Selector -->
        <div class="flex gap-2 mb-2">
            <button
                type="button"
                @click="inputMode = 'wgs84'"
                :class="[
                    'px-3 py-1.5 text-sm font-medium rounded-md',
                    inputMode === 'wgs84'
                        ? 'bg-indigo-600 text-white'
                        : 'bg-gray-200 text-gray-700 hover:bg-gray-300',
                ]"
            >
                Lat/Lng
            </button>
            <button
                type="button"
                @click="inputMode = 'swiss'"
                :class="[
                    'px-3 py-1.5 text-sm font-medium rounded-md',
                    inputMode === 'swiss'
                        ? 'bg-indigo-600 text-white'
                        : 'bg-gray-200 text-gray-700 hover:bg-gray-300',
                ]"
            >
                Swiss (E/N)
            </button>
        </div>

        <!-- Coordinate Inputs -->
        <div v-if="inputMode === 'wgs84'" class="grid grid-cols-2 gap-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1"> Latitude (N/S) </label>
                <input
                    type="number"
                    step="any"
                    v-model.number="localLatitude"
                    @input="onWgs84Change"
                    placeholder="46.8182"
                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                />
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">
                    Longitude (E/W)
                </label>
                <input
                    type="number"
                    step="any"
                    v-model.number="localLongitude"
                    @input="onWgs84Change"
                    placeholder="8.2275"
                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                />
            </div>
        </div>

        <div v-else class="grid grid-cols-2 gap-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1"> Easting (E) </label>
                <input
                    type="number"
                    step="1"
                    v-model.number="swissEasting"
                    @input="onSwissChange"
                    placeholder="2600000"
                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                />
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1"> Northing (N) </label>
                <input
                    type="number"
                    step="1"
                    v-model.number="swissNorthing"
                    @input="onSwissChange"
                    placeholder="1200000"
                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                />
            </div>
        </div>

        <!-- Map Picker -->
        <div class="space-y-2">
            <div class="flex justify-between items-center">
                <label class="block text-sm font-medium text-gray-700">
                    Pick location on map
                </label>
                <button
                    v-if="hasCoordinates"
                    type="button"
                    @click="clearCoordinates"
                    class="text-sm text-red-600 hover:text-red-700"
                >
                    Clear
                </button>
            </div>
            <div
                ref="mapContainer"
                class="w-full h-96 rounded-lg overflow-hidden border border-gray-300 cursor-crosshair"
            ></div>
            <p class="text-xs text-gray-500">
                Click on the map to set the location. You can also drag the marker to adjust the
                position.
            </p>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onActivated, watch, computed } from "vue"
import { convertLv95ToWgs84, convertWgs84ToLv95 } from "@/utils/coordinates"
import { useGoogleMaps } from "@/composables/useGoogleMaps"

interface Props {
    latitude?: number | null
    longitude?: number | null
}

interface Emits {
    (e: "update:latitude", value: number | null): void
    (e: "update:longitude", value: number | null): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

const { loadGoogleMapsScript } = useGoogleMaps()

const mapContainer = ref<HTMLDivElement | null>(null)
const inputMode = ref<"wgs84" | "swiss">("wgs84")

// Local coordinate states
const localLatitude = ref<number | null>(props.latitude ?? null)
const localLongitude = ref<number | null>(props.longitude ?? null)
const swissEasting = ref<number | null>(null)
const swissNorthing = ref<number | null>(null)

let map: google.maps.Map | null = null
let marker: google.maps.marker.AdvancedMarkerElement | null = null

// Google Maps API key from environment variables
const MAP_ID = "BEG_LOCATION_PICKER_MAP"
const SWITZERLAND_CENTER = { lat: 46.8, lng: 8.2 }

const hasCoordinates = computed(() => localLatitude.value !== null && localLongitude.value !== null)

const initMap = async () => {
    if (!mapContainer.value) return

    try {
        await loadGoogleMapsScript()

        const initialCenter = hasCoordinates.value
            ? { lat: localLatitude.value!, lng: localLongitude.value! }
            : SWITZERLAND_CENTER

        map = new google.maps.Map(mapContainer.value, {
            center: initialCenter,
            zoom: hasCoordinates.value ? 14 : 8,
            mapTypeId: google.maps.MapTypeId.HYBRID,
            mapTypeControl: true,
            streetViewControl: false,
            fullscreenControl: true,
            mapId: MAP_ID,
        })

        // Add initial marker if coordinates exist
        if (hasCoordinates.value) {
            createMarker({ lat: localLatitude.value!, lng: localLongitude.value! })
        }

        // Add click listener to map
        map.addListener("click", (e: google.maps.MapMouseEvent) => {
            if (e.latLng) {
                const lat = e.latLng.lat()
                const lng = e.latLng.lng()
                updateCoordinates(lat, lng)
                createMarker({ lat, lng })
            }
        })
    } catch (error) {
        console.error("Error loading Google Maps:", error)
    }
}

const createMarker = (position: { lat: number; lng: number }) => {
    if (!map) return

    if (marker) {
        marker.position = position
    } else {
        marker = new google.maps.marker.AdvancedMarkerElement({
            map,
            position,
            gmpDraggable: true,
        })

        // Add drag listener
        marker.addListener("dragend", (event: any) => {
            const position = event.latLng
            if (position) {
                const lat = position.lat()
                const lng = position.lng()
                updateCoordinates(lat, lng)
            }
        })
    }

    map.setCenter(position)
}

const updateCoordinates = (lat: number, lng: number) => {
    localLatitude.value = lat
    localLongitude.value = lng

    // Update Swiss coordinates
    const converted = convertWgs84ToLv95(lat, lng)
    if (converted) {
        swissEasting.value = converted.easting
        swissNorthing.value = converted.northing
    }

    // Emit changes
    emit("update:latitude", lat)
    emit("update:longitude", lng)
}

const onWgs84Change = () => {
    if (
        localLatitude.value !== null &&
        localLongitude.value !== null &&
        Number.isFinite(localLatitude.value) &&
        Number.isFinite(localLongitude.value)
    ) {
        // Update Swiss coordinates
        const converted = convertWgs84ToLv95(localLatitude.value, localLongitude.value)
        if (converted) {
            swissEasting.value = converted.easting
            swissNorthing.value = converted.northing
        }

        // Update marker on map
        if (map) {
            createMarker({ lat: localLatitude.value, lng: localLongitude.value })
        }

        // Emit changes
        emit("update:latitude", localLatitude.value)
        emit("update:longitude", localLongitude.value)
    }
}

const onSwissChange = () => {
    if (
        swissEasting.value !== null &&
        swissNorthing.value !== null &&
        Number.isFinite(swissEasting.value) &&
        Number.isFinite(swissNorthing.value)
    ) {
        // Convert Swiss to WGS84
        const converted = convertLv95ToWgs84(swissEasting.value, swissNorthing.value)
        localLatitude.value = converted.latitude
        localLongitude.value = converted.longitude

        // Update marker on map
        if (map) {
            createMarker({ lat: converted.latitude, lng: converted.longitude })
        }

        // Emit changes
        emit("update:latitude", converted.latitude)
        emit("update:longitude", converted.longitude)
    }
}

const clearCoordinates = () => {
    localLatitude.value = null
    localLongitude.value = null
    swissEasting.value = null
    swissNorthing.value = null

    if (marker) {
        marker.map = null
        marker = null
    }

    if (map) {
        map.setCenter(SWITZERLAND_CENTER)
        map.setZoom(8)
    }

    emit("update:latitude", null)
    emit("update:longitude", null)
}

// Watch for external prop changes
watch(
    [() => props.latitude, () => props.longitude],
    ([newLat, newLng]) => {
        if (newLat !== localLatitude.value || newLng !== localLongitude.value) {
            localLatitude.value = newLat ?? null
            localLongitude.value = newLng ?? null

            // Update Swiss coordinates
            if (newLat !== null && newLng !== null) {
                const converted = convertWgs84ToLv95(newLat, newLng)
                if (converted) {
                    swissEasting.value = converted.easting
                    swissNorthing.value = converted.northing
                }

                // Update map
                if (map) {
                    createMarker({ lat: newLat, lng: newLng })
                }
            }
        }
    },
    { immediate: true }
)

onMounted(() => {
    initMap()
})

// Handle component reactivation when using KeepAlive
onActivated(() => {
    marker = null
    updateMarker()
})

const updateMarker = () => {
    if (!map || !hasCoordinates.value) return

    createMarker({ lat: localLatitude.value!, lng: localLongitude.value! })
}
</script>
