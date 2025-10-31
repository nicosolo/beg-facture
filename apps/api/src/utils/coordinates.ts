const LV95_EASTING_OFFSET = 2600000
const LV95_NORTHING_OFFSET = 1200000

export type Wgs84Coordinates = {
    latitude: number
    longitude: number
}

export type Lv95Coordinates = {
    easting: number
    northing: number
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
