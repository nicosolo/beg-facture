import { and, desc, eq, gte, lte, sql } from "drizzle-orm"
import { db } from "../index"
import {
    invoices,
    invoiceRates,
    invoiceOffers,
    invoiceAdjudications,
    projects,
    activities,
    clients,
} from "../schema"
import type { InvoiceCreateInput, InvoiceUpdateInput, InvoiceFilter } from "@beg/validations"
import { projectRepository } from "./project.repository"
import type { Variables } from "@src/types/global"
import { hasRole } from "@src/tools/role-middleware"

export const invoiceRepository = {
    async findAll(user: Variables["user"], filter: InvoiceFilter) {
        const where = []

        // Access control
        if (!hasRole(user.role, "admin")) {
            // Get all projects the user has access to
            const userProjects = await projectRepository.findAll(user, {
                sortBy: "name",
                sortOrder: "asc",
                page: 1,
                limit: 1000,
                hasUnbilledTime: false,
                includeArchived: false,
                includeEnded: true,
            })
            const projectIds = userProjects.data.map((p) => p.id)
            if (projectIds.length === 0) {
                return {
                    data: [],
                    total: 0,
                    page: filter.page || 1,
                    limit: filter.limit || 20,
                }
            }
            where.push(sql`${invoices.projectId} IN (${sql.join(projectIds, sql`, `)})`)
        }

        // Apply filters
        if (filter.projectId) {
            where.push(eq(invoices.projectId, filter.projectId))
        }
        if (filter.status) {
            where.push(eq(invoices.status, filter.status))
        }
        if (filter.fromDate) {
            where.push(gte(invoices.issueDate, filter.fromDate))
        }
        if (filter.toDate) {
            where.push(lte(invoices.issueDate, filter.toDate))
        }

        const whereClause = where.length > 0 ? and(...where) : undefined

        // Get total count
        const [{ total }] = await db
            .select({ total: sql<number>`count(*)` })
            .from(invoices)
            .where(whereClause)

        // Get paginated data
        const limit = filter.limit || 20
        const offset = ((filter.page || 1) - 1) * limit

        let orderBy
        switch (filter.sortBy) {
            case "reference":
                orderBy = filter.sortOrder === "asc" ? invoices.reference : desc(invoices.reference)
                break
            case "total":
                orderBy = filter.sortOrder === "asc" ? invoices.totalTTC : desc(invoices.totalTTC)
                break
            case "status":
                orderBy = filter.sortOrder === "asc" ? invoices.status : desc(invoices.status)
                break
            case "date":
            default:
                orderBy = filter.sortOrder === "asc" ? invoices.issueDate : desc(invoices.issueDate)
                break
        }

        const data = await db
            .select({
                invoice: invoices,
                project: projects,
                client: clients,
            })
            .from(invoices)
            .leftJoin(projects, eq(invoices.projectId, projects.id))
            .leftJoin(clients, eq(projects.clientId, clients.id))
            .where(whereClause)
            .orderBy(orderBy)
            .limit(limit)
            .offset(offset)

        // Transform data to match response schema
        const transformedData = await Promise.all(
            data.map(async (row) => {
                const rates = await db
                    .select()
                    .from(invoiceRates)
                    .where(eq(invoiceRates.invoiceId, row.invoice.id))

                const offers = await db
                    .select()
                    .from(invoiceOffers)
                    .where(eq(invoiceOffers.invoiceId, row.invoice.id))

                const adjudications = await db
                    .select()
                    .from(invoiceAdjudications)
                    .where(eq(invoiceAdjudications.invoiceId, row.invoice.id))

                return {
                    // Basic fields
                    id: row.invoice.id,
                    projectId: row.invoice.projectId,
                    invoiceNumber: row.invoice.invoiceNumber,
                    reference: row.invoice.reference,
                    type: row.invoice.type,
                    billingMode: row.invoice.billingMode,
                    status: row.invoice.status,
                    description: row.invoice.description,
                    note: row.invoice.note,
                    invoiceDocument: row.invoice.invoiceDocument,
                    visaBy: row.invoice.visaBy,
                    visaDate: row.invoice.visaDate,

                    // Dates - flat
                    issueDate: row.invoice.issueDate,
                    dueDate: row.invoice.dueDate,
                    periodStart: row.invoice.periodStart,
                    periodEnd: row.invoice.periodEnd,
                    period: row.invoice.period,

                    // Client - flat
                    clientAddress: row.invoice.clientAddress || "",
                    recipientAddress: row.invoice.recipientAddress || "",
                    // Fees - flat
                    feesBase: row.invoice.feesBase,
                    feesAdjusted: row.invoice.feesAdjusted,
                    feesTotal: row.invoice.feesTotal,
                    feesOthers: row.invoice.feesOthers,
                    feesFinalTotal: row.invoice.feesFinalTotal,
                    feesMultiplicationFactor: row.invoice.feesMultiplicationFactor,
                    feesDiscountPercentage: row.invoice.feesDiscountPercentage,
                    feesDiscountAmount: row.invoice.feesDiscountAmount,

                    // Expenses - flat
                    expensesTravelBase: row.invoice.expensesTravelBase,
                    expensesTravelAdjusted: row.invoice.expensesTravelAdjusted,
                    expensesTravelRate: row.invoice.expensesTravelRate,
                    expensesTravelAmount: row.invoice.expensesTravelAmount,
                    expensesOtherBase: row.invoice.expensesOtherBase,
                    expensesOtherAmount: row.invoice.expensesOtherAmount,
                    expensesThirdPartyAmount: row.invoice.expensesThirdPartyAmount,
                    expensesPackagePercentage: row.invoice.expensesPackagePercentage,
                    expensesPackageAmount: row.invoice.expensesPackageAmount,
                    expensesTotalExpenses: row.invoice.expensesTotalExpenses,

                    // Totals - flat
                    totalHT: row.invoice.totalHT,
                    vatRate: row.invoice.vatRate,
                    vatAmount: row.invoice.vatAmount,
                    totalTTC: row.invoice.totalTTC,

                    // Other services and remarks - flat
                    otherServices: row.invoice.otherServices || "",
                    remarksOtherServices: row.invoice.remarksOtherServices || "",
                    remarksTravelExpenses: row.invoice.remarksTravelExpenses || "",
                    remarksExpenses: row.invoice.remarksExpenses || "",
                    remarksThirdPartyExpenses: row.invoice.remarksThirdPartyExpenses || "",

                    // Arrays
                    rates: rates.map((r) => ({
                        rateClass: r.rateClass,
                        base: r.baseMinutes / 60, // Convert minutes to hours
                        adjusted: r.adjustedMinutes / 60,
                        hourlyRate: r.hourlyRate,
                        amount: r.amount,
                    })),
                    offers: offers.map((o) => ({
                        file: o.file,
                        date: o.date,
                        amount: o.amount,
                        remark: o.remark || "",
                    })),
                    adjudications: adjudications.map((a) => ({
                        file: a.file,
                        date: a.date,
                        amount: a.amount,
                        remark: a.remark || "",
                    })),

                    // Project info - flat
                    project: {
                        id: row.project?.id || null,
                        name: row.project?.name || null,
                        projectNumber: row.project?.projectNumber || null,
                        subProjectName: row.project?.subProjectName || null,
                        client: row.client || null,
                    },

                    // Timestamps
                    createdAt: row.invoice.createdAt,
                    updatedAt: row.invoice.updatedAt,
                }
            })
        )
        return {
            data: transformedData,
            total,
            page: filter.page || 1,
            limit: limit,
            totalPages: Math.ceil(total / limit),
        }
    },

    async findById(id: number, user: Variables["user"]) {
        const result = await db
            .select({
                invoice: invoices,
                project: projects,
                client: clients,
            })
            .from(invoices)
            .leftJoin(projects, eq(invoices.projectId, projects.id))
            .leftJoin(clients, eq(projects.clientId, clients.id))
            .where(eq(invoices.id, id))
            .limit(1)

        if (!result.length) {
            return null
        }

        const row = result[0]

        // Check access
        if (!hasRole(user.role, "admin")) {
            const hasAccess = await projectRepository.findById(row.invoice.projectId, user)
            if (!hasAccess) {
                return null
            }
        }

        // Get related data
        const rates = await db.select().from(invoiceRates).where(eq(invoiceRates.invoiceId, id))

        const offers = await db.select().from(invoiceOffers).where(eq(invoiceOffers.invoiceId, id))

        const adjudications = await db
            .select()
            .from(invoiceAdjudications)
            .where(eq(invoiceAdjudications.invoiceId, id))

        // Transform and return - fully flat structure
        return {
            // Basic fields
            id: row.invoice.id,
            projectId: row.invoice.projectId,
            invoiceNumber: row.invoice.invoiceNumber,
            reference: row.invoice.reference,
            type: row.invoice.type,
            billingMode: row.invoice.billingMode,
            status: row.invoice.status,
            description: row.invoice.description,
            note: row.invoice.note,
            invoiceDocument: row.invoice.invoiceDocument,
            visaBy: row.invoice.visaBy,
            visaDate: row.invoice.visaDate,

            // Dates - flat
            issueDate: row.invoice.issueDate,
            dueDate: row.invoice.dueDate,
            periodStart: row.invoice.periodStart,
            periodEnd: row.invoice.periodEnd,
            period: row.invoice.period,

            // Client - flat
            clientAddress: row.invoice.clientAddress || "",
            recipientAddress: row.invoice.recipientAddress || "",

            // Fees - flat
            feesBase: row.invoice.feesBase,
            feesAdjusted: row.invoice.feesAdjusted,
            feesTotal: row.invoice.feesTotal,
            feesOthers: row.invoice.feesOthers,
            feesFinalTotal: row.invoice.feesFinalTotal,
            feesMultiplicationFactor: row.invoice.feesMultiplicationFactor,
            feesDiscountPercentage: row.invoice.feesDiscountPercentage,
            feesDiscountAmount: row.invoice.feesDiscountAmount,

            // Expenses - flat
            expensesTravelBase: row.invoice.expensesTravelBase,
            expensesTravelAdjusted: row.invoice.expensesTravelAdjusted,
            expensesTravelRate: row.invoice.expensesTravelRate,
            expensesTravelAmount: row.invoice.expensesTravelAmount,
            expensesOtherBase: row.invoice.expensesOtherBase,
            expensesOtherAmount: row.invoice.expensesOtherAmount,
            expensesThirdPartyAmount: row.invoice.expensesThirdPartyAmount,
            expensesPackagePercentage: row.invoice.expensesPackagePercentage,
            expensesPackageAmount: row.invoice.expensesPackageAmount,
            expensesTotalExpenses: row.invoice.expensesTotalExpenses,

            // Totals - flat
            totalHT: row.invoice.totalHT,
            vatRate: row.invoice.vatRate,
            vatAmount: row.invoice.vatAmount,
            totalTTC: row.invoice.totalTTC,

            // Other services and remarks - flat
            otherServices: row.invoice.otherServices || "",
            remarksOtherServices: row.invoice.remarksOtherServices || "",
            remarksTravelExpenses: row.invoice.remarksTravelExpenses || "",
            remarksExpenses: row.invoice.remarksExpenses || "",
            remarksThirdPartyExpenses: row.invoice.remarksThirdPartyExpenses || "",

            // Arrays
            rates: rates.map((r) => ({
                rateClass: r.rateClass,
                base: r.baseMinutes / 60, // Convert minutes to hours
                adjusted: r.adjustedMinutes / 60,
                hourlyRate: r.hourlyRate,
                amount: r.amount,
            })),
            offers: offers.map((o) => ({
                file: o.file,
                date: o.date,
                amount: o.amount,
                remark: o.remark || "",
            })),
            adjudications: adjudications.map((a) => ({
                file: a.file,
                date: a.date,
                amount: a.amount,
                remark: a.remark || "",
            })),

            // Project info - flat
            project: {
                id: row.project?.id || null,
                name: row.project?.name || null,
                projectNumber: row.project?.projectNumber || null,
                subProjectName: row.project?.subProjectName || null,
                client: row.client || null,
            },

            // Timestamps
            createdAt: row.invoice.createdAt,
            updatedAt: row.invoice.updatedAt,
        }
    },

    async create(data: InvoiceCreateInput, user: Variables["user"]) {
        // Check project access
        const project = await projectRepository.findById(data.projectId, user)
        if (!project) {
            throw new Error("Project not found or access denied")
        }

        // Start transaction
        return await db.transaction(async (tx) => {
            const now = new Date()
            // Create invoice
            const [invoice] = await tx
                .insert(invoices)
                .values({
                    projectId: data.projectId,
                    invoiceNumber:
                        data.invoiceNumber ||
                        `${data.projectId} F ${now.getFullYear()}-${now.getMonth() + 1}-${now.getDate()}`,
                    reference: data.reference || null,
                    type: data.type,
                    billingMode: data.billingMode,
                    status: data.status,
                    issueDate: data.issueDate,
                    dueDate: data.dueDate,
                    periodStart: data.periodStart,
                    periodEnd: data.periodEnd,
                    period: data.period || null,
                    clientAddress: data.clientAddress,
                    recipientAddress: data.recipientAddress,
                    description: data.description,
                    note: data.note,
                    invoiceDocument: data.invoiceDocument || null,
                    visaBy: data.visaBy || null,
                    visaDate: data.visaDate || null,
                    // Store real values directly - all flat fields
                    feesBase: data.feesBase,
                    feesAdjusted: data.feesAdjusted,
                    feesTotal: data.feesTotal,
                    feesOthers: data.feesOthers,
                    feesFinalTotal: data.feesFinalTotal,
                    feesMultiplicationFactor: data.feesMultiplicationFactor,
                    feesDiscountPercentage: data.feesDiscountPercentage || null,
                    feesDiscountAmount: data.feesDiscountAmount || null,
                    expensesTravelBase: data.expensesTravelBase,
                    expensesTravelAdjusted: data.expensesTravelAdjusted,
                    expensesTravelRate: data.expensesTravelRate,
                    expensesTravelAmount: data.expensesTravelAmount,
                    expensesOtherBase: data.expensesOtherBase,
                    expensesOtherAmount: data.expensesOtherAmount,
                    expensesThirdPartyAmount: data.expensesThirdPartyAmount,
                    expensesPackagePercentage: data.expensesPackagePercentage || null,
                    expensesPackageAmount: data.expensesPackageAmount || null,
                    expensesTotalExpenses: data.expensesTotalExpenses,
                    totalHT: data.totalHT,
                    vatRate: data.vatRate,
                    vatAmount: data.vatAmount,
                    totalTTC: data.totalTTC,
                    otherServices: data.otherServices,
                    remarksOtherServices: data.remarksOtherServices,
                    remarksTravelExpenses: data.remarksTravelExpenses,
                    remarksExpenses: data.remarksExpenses,
                    remarksThirdPartyExpenses: data.remarksThirdPartyExpenses,
                    createdAt: new Date(),
                    updatedAt: new Date(),
                })
                .returning()

            // Create rates
            if (data.rates && data.rates.length > 0) {
                await tx.insert(invoiceRates).values(
                    data.rates.map((rate) => ({
                        invoiceId: invoice.id,
                        rateClass: rate.rateClass,
                        baseMinutes: Math.round(rate.base * 60), // Convert hours to minutes
                        adjustedMinutes: Math.round(rate.adjusted * 60),
                        hourlyRate: rate.hourlyRate,
                        amount: rate.amount,
                        createdAt: new Date(),
                        updatedAt: new Date(),
                    }))
                )
            }

            // Create offers
            if (data.offers && data.offers.length > 0) {
                await tx.insert(invoiceOffers).values(
                    data.offers.map((offer) => ({
                        invoiceId: invoice.id,
                        file: offer.file,
                        date: offer.date || new Date(),
                        amount: offer.amount,
                        remark: offer.remark,
                        createdAt: new Date(),
                        updatedAt: new Date(),
                    }))
                )
            }

            // Create adjudications
            if (data.adjudications && data.adjudications.length > 0) {
                await tx.insert(invoiceAdjudications).values(
                    data.adjudications.map((adj) => ({
                        invoiceId: invoice.id,
                        file: adj.file,
                        date: adj.date || new Date(),
                        amount: adj.amount,
                        remark: adj.remark,
                        createdAt: new Date(),
                        updatedAt: new Date(),
                    }))
                )
            }

            // Mark activities as billed if activity IDs provided
            if (
                data.activityIds &&
                data.activityIds.length > 0 &&
                !["accordingToOffer", "accordingToInvoice"].includes(data.billingMode)
            ) {
                await tx
                    .update(activities)
                    .set({
                        invoiceId: invoice.id,
                        updatedAt: new Date(),
                    })
                    .where(
                        sql`${activities.id} IN (${sql.join(
                            data.activityIds.map((id) => sql`${id}`),
                            sql`, `
                        )})`
                    )
            }

            // Return the created invoice
            return this.findById(invoice.id, user)
        })
    },

    async update(id: number, data: Partial<InvoiceUpdateInput>, user: Variables["user"]) {
        // Check access
        const existing = await this.findById(id, user)
        if (!existing) {
            return null
        }

        // Start transaction
        return await db.transaction(async (tx) => {
            const updateData: any = {
                updatedAt: new Date(),
            }

            // Map flat fields directly
            if (data.invoiceNumber !== undefined) updateData.invoiceNumber = data.invoiceNumber
            if (data.reference !== undefined) updateData.reference = data.reference
            if (data.type !== undefined) updateData.type = data.type
            if (data.billingMode !== undefined) updateData.billingMode = data.billingMode
            if (data.status !== undefined) updateData.status = data.status
            if (data.issueDate !== undefined) updateData.issueDate = data.issueDate
            if (data.dueDate !== undefined) updateData.dueDate = data.dueDate
            if (data.description !== undefined) updateData.description = data.description
            if (data.note !== undefined) updateData.note = data.note
            if (data.invoiceDocument !== undefined)
                updateData.invoiceDocument = data.invoiceDocument
            if (data.visaBy !== undefined) updateData.visaBy = data.visaBy
            if (data.visaDate !== undefined) updateData.visaDate = data.visaDate

            // Period dates
            if (data.periodStart !== undefined) updateData.periodStart = data.periodStart
            if (data.periodEnd !== undefined) updateData.periodEnd = data.periodEnd
            if (data.period !== undefined) updateData.period = data.period

            // Client and recipient
            if (data.clientAddress !== undefined) updateData.clientAddress = data.clientAddress
            if (data.recipientAddress !== undefined)
                updateData.recipientAddress = data.recipientAddress

            // Fees - flat fields
            if (data.feesBase !== undefined) updateData.feesBase = data.feesBase
            if (data.feesAdjusted !== undefined) updateData.feesAdjusted = data.feesAdjusted
            if (data.feesTotal !== undefined) updateData.feesTotal = data.feesTotal
            if (data.feesOthers !== undefined) updateData.feesOthers = data.feesOthers
            if (data.feesFinalTotal !== undefined) updateData.feesFinalTotal = data.feesFinalTotal
            if (data.feesMultiplicationFactor !== undefined)
                updateData.feesMultiplicationFactor = data.feesMultiplicationFactor
            if (data.feesDiscountPercentage !== undefined)
                updateData.feesDiscountPercentage = data.feesDiscountPercentage
            if (data.feesDiscountAmount !== undefined)
                updateData.feesDiscountAmount = data.feesDiscountAmount

            // Expenses - flat fields
            if (data.expensesTravelBase !== undefined)
                updateData.expensesTravelBase = data.expensesTravelBase
            if (data.expensesTravelAdjusted !== undefined)
                updateData.expensesTravelAdjusted = data.expensesTravelAdjusted
            if (data.expensesTravelRate !== undefined)
                updateData.expensesTravelRate = data.expensesTravelRate
            if (data.expensesTravelAmount !== undefined)
                updateData.expensesTravelAmount = data.expensesTravelAmount
            if (data.expensesOtherBase !== undefined)
                updateData.expensesOtherBase = data.expensesOtherBase
            if (data.expensesOtherAmount !== undefined)
                updateData.expensesOtherAmount = data.expensesOtherAmount
            if (data.expensesThirdPartyAmount !== undefined)
                updateData.expensesThirdPartyAmount = data.expensesThirdPartyAmount
            if (data.expensesPackagePercentage !== undefined)
                updateData.expensesPackagePercentage = data.expensesPackagePercentage
            if (data.expensesPackageAmount !== undefined)
                updateData.expensesPackageAmount = data.expensesPackageAmount
            if (data.expensesTotalExpenses !== undefined)
                updateData.expensesTotalExpenses = data.expensesTotalExpenses

            // Totals - flat fields
            if (data.totalHT !== undefined) updateData.totalHT = data.totalHT
            if (data.vatRate !== undefined) updateData.vatRate = data.vatRate
            if (data.vatAmount !== undefined) updateData.vatAmount = data.vatAmount
            if (data.totalTTC !== undefined) updateData.totalTTC = data.totalTTC

            // Other services and remarks
            if (data.otherServices !== undefined) updateData.otherServices = data.otherServices
            if (data.remarksOtherServices !== undefined)
                updateData.remarksOtherServices = data.remarksOtherServices
            if (data.remarksTravelExpenses !== undefined)
                updateData.remarksTravelExpenses = data.remarksTravelExpenses
            if (data.remarksExpenses !== undefined)
                updateData.remarksExpenses = data.remarksExpenses
            if (data.remarksThirdPartyExpenses !== undefined)
                updateData.remarksThirdPartyExpenses = data.remarksThirdPartyExpenses

            // Update rates if provided
            if (data.rates) {
                // Delete existing rates
                await tx.delete(invoiceRates).where(eq(invoiceRates.invoiceId, id))
                // Insert new rates
                if (data.rates.length > 0) {
                    await tx.insert(invoiceRates).values(
                        data.rates.map((rate) => ({
                            invoiceId: id,
                            rateClass: rate.rateClass,
                            baseMinutes: Math.round(rate.base * 60),
                            adjustedMinutes: Math.round(rate.adjusted * 60),
                            hourlyRate: rate.hourlyRate,
                            amount: rate.amount,
                            createdAt: new Date(),
                            updatedAt: new Date(),
                        }))
                    )
                }
            }

            // Update invoice
            await tx.update(invoices).set(updateData).where(eq(invoices.id, id))

            // Update offers if provided
            if (data.offers) {
                await tx.delete(invoiceOffers).where(eq(invoiceOffers.invoiceId, id))
                if (data.offers.length > 0) {
                    await tx.insert(invoiceOffers).values(
                        data.offers.map((offer) => ({
                            invoiceId: id,
                            file: offer.file,
                            date: offer.date || new Date(),
                            amount: offer.amount,
                            remark: offer.remark,
                            createdAt: new Date(),
                            updatedAt: new Date(),
                        }))
                    )
                }
            }

            // Update adjudications if provided
            if (data.adjudications) {
                await tx.delete(invoiceAdjudications).where(eq(invoiceAdjudications.invoiceId, id))
                if (data.adjudications.length > 0) {
                    await tx.insert(invoiceAdjudications).values(
                        data.adjudications.map((adj) => ({
                            invoiceId: id,
                            file: adj.file,
                            date: adj.date || new Date(),
                            amount: adj.amount,
                            remark: adj.remark,
                            createdAt: new Date(),
                            updatedAt: new Date(),
                        }))
                    )
                }
            }

            return this.findById(id, user)
        })
    },

    async delete(id: number, user: Variables["user"]) {
        const existing = await this.findById(id, user)
        if (!existing) {
            return false
        }

        await db.delete(invoices).where(eq(invoices.id, id))
        return true
    },

    async setVisa(id: number, user: Variables["user"]) {
        const invoice = await this.findById(id, user)
        if (!invoice) {
            return null
        }

        const now = new Date()

        await db
            .update(invoices)
            .set({
                visaBy: user.firstName,
                visaDate: now,
                updatedAt: now,
            })
            .where(eq(invoices.id, id))

        return {
            ...invoice,
            visaBy: user.firstName,
            visaDate: now,
            updatedAt: now,
        }
    },
}
