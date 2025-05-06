// Database configuration

// MariaDB configuration
export const DB_HOST = process.env.DB_HOST || "mariadb"
export const DB_PORT = process.env.DB_PORT || "3306"
export const DB_USER = process.env.DB_USER || "beg"
export const DB_PASSWORD = process.env.DB_PASSWORD || "rootpassword"
export const DB_DATABASE = process.env.DB_DATABASE || "beg"

// Server configuration
export const PORT = Number(process.env.PORT || 3000)

// JWT configuration
export const JWT_SECRET = process.env.JWT_SECRET || "your-secret-key-should-be-in-env"
