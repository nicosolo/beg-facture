import { readFileSync } from "fs"

// Load types.jsonc
const typesJson = readFileSync("./data/types.jsonc", "utf-8")
    .trim()
    .split("\n")
    .filter((line) => line.trim())
    .map((line) => JSON.parse(line))

// Load TSV and extract Current column (first column after line number format)
const tsvLines = readFileSync("./initial-data/projectTypes.tsv", "utf-8")
    .trim()
    .split("\n")
    .slice(1) // skip header

const currentTypes = new Set(
    tsvLines.map((line) => line.split("\t")[0].trim()).filter((t) => t && t !== "×" && t !== "x")
)

// Check each type from JSON
const missing = []
const found = []

for (const { IDtype, Type } of typesJson) {
    const normalized = Type.trim()
    if (normalized === "×" || normalized === "x") continue

    if (currentTypes.has(normalized)) {
        found.push({ IDtype, Type: normalized })
    } else {
        missing.push({ IDtype, Type: normalized })
    }
}

console.log(`Found: ${found.length}`)
console.log(`Missing: ${missing.length}\n`)

if (missing.length > 0) {
    console.log("Missing types:")
    for (const { IDtype, Type } of missing) {
        console.log(`  [${IDtype}] "${Type}"`)
    }
}
