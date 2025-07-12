import { defineStore } from "pinia"
import { ref } from "vue"
import { type UserResponse } from "@beg/validations"
import { useLogin } from "@/composables/api/useLogin"

export const useAuthStore = defineStore("auth", () => {
    const token = ref<string | null>(localStorage.getItem("auth_token"))
    const user = ref<UserResponse | null>(null)
    const isAuthenticated = ref(!!token.value)

    // Create API handler for login endpoint
    const { post: postLogin, error: loginError, data: loginData } = useLogin()

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
            await postLogin({ body: { email, password } })

            if (loginError.value) {
                throw new Error(loginError.value || "Login failed")
            }

            if (loginData.value) {
                token.value = loginData.value.token
                user.value = loginData.value.user
                isAuthenticated.value = true

                // Store in localStorage
                localStorage.setItem("auth_token", loginData.value.token)
                localStorage.setItem("auth_user", JSON.stringify(loginData.value.user))

                return true
            }
            return false
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
        return token.value ? { Authorization: `Bearer ${token.value}` } : { Authorization: "" }
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
