import { db } from "./index"
import { users } from "./schema"
import bcrypt from "bcrypt"
import { runMigrations } from "./migrate"
import { eq } from "drizzle-orm"

async function seed() {
    // First run migrations to ensure database is up to date
    await runMigrations()

    // Check if the admin user already exists
    const existingUser = await db.select().from(users).where(eq(users.email, "n@solioz.me")).get()

    if (!existingUser) {
        // Hash the password
        const hashedPassword = await bcrypt.hash("qwerqwer", 10)

        // Insert the admin user
        await db.insert(users).values({
            email: "n@solioz.me",
            firstName: "Nicolas",
            lastName: "Solioz",
            initials: "NS",
            password: hashedPassword,
            role: "admin",
            archived: false,
            createdAt: new Date(),
            updatedAt: new Date(),
        })

        console.log("Admin user created successfully")
    } else {
        console.log("Admin user already exists")
    }
}

// Run seed if this file is executed directly
if (import.meta.path === Bun.main) {
    seed()
        .then(() => {
            console.log("Seeding completed")
            process.exit(0)
        })
        .catch((error) => {
            console.error("Error seeding database:", error)
            process.exit(1)
        })
}
