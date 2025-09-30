const GEO_ADMIN_BASE_URL = "https://map.geo.admin.ch/"
const GEO_ADMIN_EMBED_URL = "https://map.geo.admin.ch/embed.html"
const GOOGLE_MAPS_BASE_URL = "https://www.google.com/maps/search/"

export type BuildGeoAdminUrlOptions = {
    zoom?: number
    embed?: boolean
}

export function buildGeoAdminUrl(
    easting?: number | null,
    northing?: number | null,
    zoomOrOptions?: number | BuildGeoAdminUrlOptions
): string | null {
    if (!Number.isFinite(easting) || !Number.isFinite(northing)) {
        return null
    }

    let zoom = 11
    let embed = false

    if (typeof zoomOrOptions === "number") {
        zoom = zoomOrOptions
    } else if (typeof zoomOrOptions === "object" && zoomOrOptions !== null) {
        zoom = zoomOrOptions.zoom ?? zoom
        embed = zoomOrOptions.embed ?? embed
    }

    const params = new URLSearchParams({
        E: Math.round(easting!).toString(),
        N: Math.round(northing!).toString(),
        zoom: zoom.toString(),
        lang: "fr",
        topic: "ech",
        bgLayer: "ch.swisstopo.pixelkarte-farbe",
    })

    const baseUrl = embed ? GEO_ADMIN_EMBED_URL : GEO_ADMIN_BASE_URL

    return `${baseUrl}?${params.toString()}`
}

const LV95_EASTING_OFFSET = 2600000
const LV95_NORTHING_OFFSET = 1200000

type Wgs84Coordinates = {
    latitude: number
    longitude: number
}

const convertLv95ToWgs84 = (easting: number, northing: number): Wgs84Coordinates | null => {
    const y = (easting - LV95_EASTING_OFFSET) / 1_000_000
    const x = (northing - LV95_NORTHING_OFFSET) / 1_000_000

    if (!Number.isFinite(x) || !Number.isFinite(y)) {
        return null
    }

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
    easting?: number | null,
    northing?: number | null
): string | null {
    if (!Number.isFinite(easting) || !Number.isFinite(northing)) {
        return null
    }

    const converted = convertLv95ToWgs84(easting!, northing!)

    if (!converted) {
        return null
    }

    const params = new URLSearchParams({
        api: "1",
        query: `${converted.latitude.toFixed(6)},${converted.longitude.toFixed(6)}`,
    })

    return `${GOOGLE_MAPS_BASE_URL}?${params.toString()}`
}
