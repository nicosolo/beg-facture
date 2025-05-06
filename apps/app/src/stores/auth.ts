import { defineStore } from "pinia"
import { ref } from "vue"
import type { User } from "@beg/types"

type AuthUser = Omit<User, "password"> & { id: number }

export const useAuthStore = defineStore("auth", () => {
    const token = ref<string | null>(localStorage.getItem("auth_token"))
    const user = ref<AuthUser | null>(null)
    const isAuthenticated = ref(!!token.value)

    // Try to load user from localStorage
    try {
        const storedUser = localStorage.getItem("auth_user")
        if (storedUser) {
            user.value = JSON.parse(storedUser)
        }
    } catch (error) {
        // If there's an error parsing the stored user, we'll just ignore it
        localStorage.removeItem("auth_user")
    }

    // Login function
    async function login(email: string, password: string) {
        try {
            const response = await fetch("/api/user/login", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({ email, password }),
            })

            if (!response.ok) {
                const error = await response.json()
                throw new Error(error.error || "Login failed")
            }

            const data = await response.json()
            token.value = data.token
            user.value = data.user
            isAuthenticated.value = true

            // Store in localStorage
            localStorage.setItem("auth_token", data.token)
            localStorage.setItem("auth_user", JSON.stringify(data.user))

            return true
        } catch (error) {
            console.error("Login error:", error)
            return false
        }
    }

    // Logout function
    function logout() {
        token.value = null
        user.value = null
        isAuthenticated.value = false

        // Remove from localStorage
        localStorage.removeItem("auth_token")
        localStorage.removeItem("auth_user")
    }

    // Function to get auth headers for API requests
    function getAuthHeaders() {
        return token.value ? { Authorization: `Bearer ${token.value}` } : {}
    }

    return {
        token,
        user,
        isAuthenticated,
        login,
        logout,
        getAuthHeaders,
    }
})
