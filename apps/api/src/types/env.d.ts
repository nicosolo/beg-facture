declare global {
    namespace NodeJS {
        interface ProcessEnv {
            DATABASE_FILE_PATH: string
        }
    }
}

export {}
