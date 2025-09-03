// Simple service worker for PWA installation
// No caching strategy - just the minimum for PWA installation

const CACHE_NAME = "beg-facture-v1"

// Install event - cache only the essential files
self.addEventListener("install", (event) => {
    event.waitUntil(
        caches.open(CACHE_NAME).then((cache) => {
            return cache.addAll(["/", "/manifest.json"])
        })
    )
    // Skip waiting and activate immediately
    self.skipWaiting()
})

// Activate event - clean up old caches
self.addEventListener("activate", (event) => {
    event.waitUntil(
        caches.keys().then((cacheNames) => {
            return Promise.all(
                cacheNames.map((cacheName) => {
                    if (cacheName !== CACHE_NAME) {
                        return caches.delete(cacheName)
                    }
                })
            )
        })
    )
    // Take control of all clients immediately
    self.clients.claim()
})

// Fetch event - network first, fallback to cache only for navigation
self.addEventListener("fetch", (event) => {
    // Only handle navigation requests with cache fallback
    if (event.request.mode === "navigate") {
        event.respondWith(
            fetch(event.request).catch(() => {
                return caches.match("/")
            })
        )
        return
    }

    // For all other requests, just use network
    event.respondWith(fetch(event.request))
})
