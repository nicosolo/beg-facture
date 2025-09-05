import { db } from "./index"
import { invoices } from "./schema"
import { sql } from "drizzle-orm"

/**
 * Migration script to update existing invoice data to use new enum values
 * Converts old French labels to new enum keys
 */
async function migrateInvoiceEnums() {
    console.log("Starting invoice enum migration...")

    try {
        // Begin transaction
        await db.transaction(async (tx) => {
            // Update invoice types
            console.log("Updating invoice types...")
            
            // Map old French labels to new enum values
            const typeMapping = [
                { old: "Facture", new: "invoice" },
                { old: "Note de crédit", new: "credit_note" },
                { old: "Facture proforma", new: "proforma" },
                { old: "Devis", new: "quote" }
            ]
            
            for (const mapping of typeMapping) {
                const result = await tx.run(
                    sql`UPDATE invoices SET type = ${mapping.new} WHERE type = ${mapping.old}`
                )
                if (result.changes > 0) {
                    console.log(`  Updated ${result.changes} records from "${mapping.old}" to "${mapping.new}"`)
                }
            }

            // Update billing modes
            console.log("Updating billing modes...")
            
            const billingModeMapping = [
                { old: "Selon données présentes", new: "accordingToData" },
                { old: "Selon facture annexée", new: "accordingToInvoice" },
                { old: "Au forfait (voir notes)", new: "fixedPrice" }
            ]
            
            for (const mapping of billingModeMapping) {
                const result = await tx.run(
                    sql`UPDATE invoices SET billingMode = ${mapping.new} WHERE billingMode = ${mapping.old}`
                )
                if (result.changes > 0) {
                    console.log(`  Updated ${result.changes} records from "${mapping.old}" to "${mapping.new}"`)
                }
            }

            // Update invoice statuses
            console.log("Updating invoice statuses...")
            
            const statusMapping = [
                { old: "Brouillon", new: "draft" },
                { old: "Contrôle", new: "controle" },
                { old: "Envoyée", new: "sent" },
                { old: "Payée", new: "paid" },
                { old: "En retard", new: "overdue" },
                { old: "Annulée", new: "cancelled" }
            ]
            
            for (const mapping of statusMapping) {
                const result = await tx.run(
                    sql`UPDATE invoices SET status = ${mapping.new} WHERE status = ${mapping.old}`
                )
                if (result.changes > 0) {
                    console.log(`  Updated ${result.changes} records from "${mapping.old}" to "${mapping.new}"`)
                }
            }

            console.log("Invoice enum migration completed successfully!")
        })
    } catch (error) {
        console.error("Error during migration:", error)
        throw error
    }
}

// Run migration if this file is executed directly
if (import.meta.path === Bun.main) {
    await migrateInvoiceEnums()
        .then(() => {
            console.log("Migration completed")
            process.exit(0)
        })
        .catch((error) => {
            console.error("Migration failed:", error)
            process.exit(1)
        })
}

export { migrateInvoiceEnums }