const GEO_ADMIN_BASE_URL = "https://map.geo.admin.ch/"
const GEO_ADMIN_EMBED_URL = "https://map.geo.admin.ch/embed.html"
const GOOGLE_MAPS_BASE_URL = "https://www.google.com/maps/search/"
const LV95_EASTING_OFFSET = 2600000
const LV95_NORTHING_OFFSET = 1200000
export type BuildGeoAdminUrlOptions = {
    zoom?: number
    embed?: boolean
}

export type Wgs84Coordinates = {
    latitude: number
    longitude: number
}

export function buildGeoAdminUrl(
    longitude: number | null,
    latitude: number | null,
    zoomOrOptions?: number | BuildGeoAdminUrlOptions
): string | null {
    if (longitude === null || latitude === null) {
        return null
    }

    // Check if coordinates are in WGS84 format (lat/lng)
    const converted = convertWgs84ToLv95(latitude, longitude)
    if (!converted) {
        return null
    }
    const { easting, northing } = converted

    let zoom = 11
    let embed = false

    if (typeof zoomOrOptions === "number") {
        zoom = zoomOrOptions
    } else if (typeof zoomOrOptions === "object" && zoomOrOptions !== null) {
        zoom = zoomOrOptions.zoom ?? zoom
        embed = zoomOrOptions.embed ?? embed
    }

    const params = new URLSearchParams({
        E: Math.round(easting).toString(),
        N: Math.round(northing).toString(),
        zoom: zoom.toString(),
        lang: "fr",
        topic: "ech",
        bgLayer: "ch.swisstopo.pixelkarte-farbe",
    })

    const baseUrl = embed ? GEO_ADMIN_EMBED_URL : GEO_ADMIN_BASE_URL

    return `${baseUrl}?${params.toString()}`
}

type Lv95Coordinates = {
    easting: number
    northing: number
}

/**
 * Convert ellipsoidal angle (decimal degrees) to arcseconds
 * Based on Swiss Topo specifications
 */
function toSeconds(angle: number): number {
    const degrees = Math.floor(angle)
    const minutesFloat = (angle - degrees) * 60
    const minutes = Math.floor(minutesFloat)
    const seconds = (minutesFloat - minutes) * 60
    return seconds + minutes * 60 + degrees * 3600
}

/**
 * Convert WGS84 coordinates (latitude/longitude) to Swiss LV95 coordinates (easting/northing)
 * Based on https://github.com/idris-maps/swiss-projection
 * @param latitude - WGS84 latitude in decimal degrees
 * @param longitude - WGS84 longitude in decimal degrees
 * @returns LV95 coordinates or null if input is invalid
 */
export function convertWgs84ToLv95(latitude: number, longitude: number): Lv95Coordinates | null {
    if (!Number.isFinite(latitude) || !Number.isFinite(longitude)) {
        return null
    }

    // Convert decimal degrees to arcseconds
    const phi = toSeconds(latitude)
    const lambda = toSeconds(longitude)

    // Calculate auxiliary values (differences relative to Bern in units of 10,000 arcseconds)
    const phi2 = (phi - 169028.66) / 10000
    const lambda2 = (lambda - 26782.5) / 10000

    // Calculate LV95 easting (E)
    const easting =
        2600072.37 +
        211455.93 * lambda2 -
        10938.51 * lambda2 * phi2 -
        0.36 * lambda2 * Math.pow(phi2, 2) -
        44.54 * Math.pow(lambda2, 3)

    // Calculate LV95 northing (N)
    const northing =
        1200147.07 +
        308807.95 * phi2 +
        3745.25 * Math.pow(lambda2, 2) +
        76.63 * Math.pow(phi2, 2) -
        194.56 * Math.pow(lambda2, 2) * phi2 +
        119.79 * Math.pow(phi2, 3)

    return {
        easting: Math.round(easting),
        northing: Math.round(northing),
    }
}

/**
 * Convert Swiss LV95 coordinates (easting/northing) to WGS84 coordinates (latitude/longitude)
 * @param easting - LV95 easting coordinate
 * @param northing - LV95 northing coordinate
 * @returns WGS84 coordinates or null if input is invalid
 */
export function convertLv95ToWgs84(easting: number, northing: number): Wgs84Coordinates {
    const y = (easting - LV95_EASTING_OFFSET) / 1_000_000
    const x = (northing - LV95_NORTHING_OFFSET) / 1_000_000

    const latitude =
        16.9023892 +
        3.238272 * x -
        0.270978 * y * y -
        0.002528 * x * x -
        0.0447 * y * y * x -
        0.014 * x * x * x

    const longitude =
        2.6779094 + 4.728982 * y + 0.791484 * y * x + 0.1306 * y * x * x - 0.0436 * y * y * y

    return {
        latitude: (latitude * 100) / 36,
        longitude: (longitude * 100) / 36,
    }
}

export function buildGoogleMapsUrl(
    longitude: number | null,
    latitude: number | null
): string | null {
    if (longitude === null || latitude === null) {
        return null
    }

    const params = new URLSearchParams({
        api: "1",
        query: `${latitude.toFixed(8)},${longitude.toFixed(8)}`,
    })

    return `${GOOGLE_MAPS_BASE_URL}?${params.toString()}`
}
