import { and, desc, eq, gte, lte, sql } from "drizzle-orm"
import { db } from "../index"
import {
    invoices,
    invoiceRates,
    invoiceOffers,
    invoiceAdjudications,
    projects,
    clients,
} from "../schema"
import type {
    InvoiceCreateInput,
    InvoiceUpdateInput,
    InvoiceFilter,
    UserResponse,
} from "@beg/validations"
type User = UserResponse
import { projectRepository } from "./project.repository"
import type { Variables } from "@src/types/global"

export const invoiceRepository = {
    async findAll(user: User, filter: InvoiceFilter) {
        const where = []

        // Access control
        if (user.role !== "admin") {
            // Get all projects the user has access to
            const userProjects = await projectRepository.findAll(user, {})
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
        if (filter.clientId) {
            where.push(eq(invoices.clientId, filter.clientId))
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
            .leftJoin(clients, eq(invoices.clientId, clients.id))
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
                    id: row.invoice.id,
                    invoiceNumber: row.invoice.invoiceNumber,
                    reference: row.invoice.reference,
                    type: row.invoice.type,
                    billingMode: row.invoice.billingMode,
                    status: row.invoice.status,
                    period: {
                        startDate: row.invoice.periodStart,
                        endDate: row.invoice.periodEnd,
                    },
                    client: row.client
                        ? {
                              id: row.client.id,
                              name: row.client.name,
                              address: "", // Client address not in schema, would need to add
                          }
                        : {
                              id: row.invoice.clientId,
                              name: "",
                              address: "",
                          },
                    recipient: {
                        name: row.invoice.recipientName,
                        address: row.invoice.recipientAddress,
                    },
                    description: row.invoice.description,
                    offers: offers.map((o) => ({
                        file: o.file,
                        date: o.date,
                        amount: o.amount / 100, // Convert from cents
                        remark: o.remark || "",
                    })),
                    adjudications: adjudications.map((a) => ({
                        file: a.file,
                        date: a.date,
                        amount: a.amount / 100, // Convert from cents
                        remark: a.remark || "",
                    })),
                    fees: {
                        base: row.invoice.feesBase / 100,
                        adjusted: row.invoice.feesAdjusted / 100,
                        total: row.invoice.feesTotal / 100,
                        others: row.invoice.feesOthers / 100,
                        finalTotal: row.invoice.feesFinalTotal / 100,
                        multiplicationFactor: row.invoice.feesMultiplicationFactor / 100,
                        discount: {
                            percentage: row.invoice.feesDiscountPercentage
                                ? row.invoice.feesDiscountPercentage / 100
                                : null,
                            amount: row.invoice.feesDiscountAmount
                                ? row.invoice.feesDiscountAmount / 100
                                : null,
                        },
                        rates: rates.map((r) => ({
                            rateClass: r.rateClass,
                            base: r.baseMinutes / 60, // Convert minutes to hours
                            adjusted: r.adjustedMinutes / 60,
                            hourlyRate: r.hourlyRate / 100,
                            amount: r.amount / 100,
                        })),
                    },
                    expenses: {
                        travel: {
                            base: row.invoice.expensesTravelBase / 100,
                            adjusted: row.invoice.expensesTravelAdjusted / 100,
                            rate: row.invoice.expensesTravelRate / 100,
                            amount: row.invoice.expensesTravelAmount / 100,
                        },
                        other: {
                            base: row.invoice.expensesOtherBase / 100,
                            amount: row.invoice.expensesOtherAmount / 100,
                        },
                        total: row.invoice.expensesTotal / 100,
                        thirdParty: {
                            amount: row.invoice.expensesThirdPartyAmount / 100,
                        },
                        package: {
                            percentage: row.invoice.expensesPackagePercentage
                                ? row.invoice.expensesPackagePercentage / 100
                                : null,
                            amount: row.invoice.expensesPackageAmount
                                ? row.invoice.expensesPackageAmount / 100
                                : null,
                        },
                        totalExpenses: row.invoice.expensesTotalExpenses / 100,
                    },
                    totals: {
                        ht: row.invoice.totalHT / 100,
                        vat: {
                            rate: row.invoice.vatRate / 100,
                            amount: row.invoice.vatAmount / 100,
                        },
                        ttc: row.invoice.totalTTC / 100,
                    },
                    otherServices: row.invoice.otherServices || "",
                    remarks: {
                        otherServices: row.invoice.remarksOtherServices || "",
                        travelExpenses: row.invoice.remarksTravelExpenses || "",
                        expenses: row.invoice.remarksExpenses || "",
                        thirdPartyExpenses: row.invoice.remarksThirdPartyExpenses || "",
                    },
                    createdAt: row.invoice.createdAt,
                    updatedAt: row.invoice.updatedAt,
                    project: row.project
                        ? {
                              id: row.project.id,
                              name: row.project.name,
                              projectNumber: row.project.projectNumber,
                          }
                        : null,
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

    async findById(id: number, user: User) {
        const result = await db
            .select({
                invoice: invoices,
                project: projects,
                client: clients,
            })
            .from(invoices)
            .leftJoin(projects, eq(invoices.projectId, projects.id))
            .leftJoin(clients, eq(invoices.clientId, clients.id))
            .where(eq(invoices.id, id))
            .limit(1)

        if (!result.length) {
            return null
        }

        const row = result[0]

        // Check access
        if (user.role !== "admin") {
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

        // Transform and return
        return {
            id: row.invoice.id,
            invoiceNumber: row.invoice.invoiceNumber,
            reference: row.invoice.reference,
            type: row.invoice.type,
            billingMode: row.invoice.billingMode,
            status: row.invoice.status,
            period: {
                startDate: row.invoice.periodStart,
                endDate: row.invoice.periodEnd,
            },
            client: row.client
                ? {
                      id: row.client.id,
                      name: row.client.name,
                      address: "",
                  }
                : {
                      id: row.invoice.clientId,
                      name: "",
                      address: "",
                  },
            recipient: {
                name: row.invoice.recipientName,
                address: row.invoice.recipientAddress,
            },
            description: row.invoice.description,
            offers: offers.map((o) => ({
                file: o.file,
                date: o.date,
                amount: o.amount / 100,
                remark: o.remark || "",
            })),
            adjudications: adjudications.map((a) => ({
                file: a.file,
                date: a.date,
                amount: a.amount / 100,
                remark: a.remark || "",
            })),
            fees: {
                base: row.invoice.feesBase / 100,
                adjusted: row.invoice.feesAdjusted / 100,
                total: row.invoice.feesTotal / 100,
                others: row.invoice.feesOthers / 100,
                finalTotal: row.invoice.feesFinalTotal / 100,
                multiplicationFactor: row.invoice.feesMultiplicationFactor / 100,
                discount: {
                    percentage: row.invoice.feesDiscountPercentage
                        ? row.invoice.feesDiscountPercentage / 100
                        : null,
                    amount: row.invoice.feesDiscountAmount
                        ? row.invoice.feesDiscountAmount / 100
                        : null,
                },
                rates: rates.map((r) => ({
                    rateClass: r.rateClass,
                    base: r.baseMinutes / 60,
                    adjusted: r.adjustedMinutes / 60,
                    hourlyRate: r.hourlyRate / 100,
                    amount: r.amount / 100,
                })),
            },
            expenses: {
                travel: {
                    base: row.invoice.expensesTravelBase / 100,
                    adjusted: row.invoice.expensesTravelAdjusted / 100,
                    rate: row.invoice.expensesTravelRate / 100,
                    amount: row.invoice.expensesTravelAmount / 100,
                },
                other: {
                    base: row.invoice.expensesOtherBase / 100,
                    amount: row.invoice.expensesOtherAmount / 100,
                },
                total: row.invoice.expensesTotal / 100,
                thirdParty: {
                    amount: row.invoice.expensesThirdPartyAmount / 100,
                },
                package: {
                    percentage: row.invoice.expensesPackagePercentage
                        ? row.invoice.expensesPackagePercentage / 100
                        : null,
                    amount: row.invoice.expensesPackageAmount
                        ? row.invoice.expensesPackageAmount / 100
                        : null,
                },
                totalExpenses: row.invoice.expensesTotalExpenses / 100,
            },
            totals: {
                ht: row.invoice.totalHT / 100,
                vat: {
                    rate: row.invoice.vatRate / 100,
                    amount: row.invoice.vatAmount / 100,
                },
                ttc: row.invoice.totalTTC / 100,
            },
            otherServices: row.invoice.otherServices || "",
            remarks: {
                otherServices: row.invoice.remarksOtherServices || "",
                travelExpenses: row.invoice.remarksTravelExpenses || "",
                expenses: row.invoice.remarksExpenses || "",
                thirdPartyExpenses: row.invoice.remarksThirdPartyExpenses || "",
            },
            createdAt: row.invoice.createdAt,
            updatedAt: row.invoice.updatedAt,
            project: row.project
                ? {
                      id: row.project.id,
                      name: row.project.name,
                      projectNumber: row.project.projectNumber,
                  }
                : null,
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
            // Create invoice
            const [invoice] = await tx
                .insert(invoices)
                .values({
                    projectId: data.projectId,
                    invoiceNumber: data.invoiceNumber,
                    reference: data.reference,
                    type: data.type,
                    billingMode: data.billingMode,
                    status: data.status,
                    issueDate: data.issueDate,
                    dueDate: data.dueDate,
                    periodStart: data.period.startDate,
                    periodEnd: data.period.endDate,
                    clientId: data.client.id,
                    recipientName: data.recipient.name,
                    recipientAddress: data.recipient.address,
                    description: data.description,
                    // Convert to cents for storage
                    feesBase: Math.round(data.fees.base * 100),
                    feesAdjusted: Math.round(data.fees.adjusted * 100),
                    feesTotal: Math.round(data.fees.total * 100),
                    feesOthers: Math.round(data.fees.others * 100),
                    feesFinalTotal: Math.round(data.fees.finalTotal * 100),
                    feesMultiplicationFactor: Math.round(data.fees.multiplicationFactor * 100),
                    feesDiscountPercentage: data.fees.discount?.percentage
                        ? Math.round(data.fees.discount.percentage * 100)
                        : null,
                    feesDiscountAmount: data.fees.discount?.amount
                        ? Math.round(data.fees.discount.amount * 100)
                        : null,
                    expensesTravelBase: Math.round(data.expenses.travel.base * 100),
                    expensesTravelAdjusted: Math.round(data.expenses.travel.adjusted * 100),
                    expensesTravelRate: Math.round(data.expenses.travel.rate * 100),
                    expensesTravelAmount: Math.round(data.expenses.travel.amount * 100),
                    expensesOtherBase: Math.round(data.expenses.other.base * 100),
                    expensesOtherAmount: Math.round(data.expenses.other.amount * 100),
                    expensesTotal: Math.round(data.expenses.total * 100),
                    expensesThirdPartyAmount: Math.round(data.expenses.thirdParty.amount * 100),
                    expensesPackagePercentage: data.expenses.package?.percentage
                        ? Math.round(data.expenses.package.percentage * 100)
                        : null,
                    expensesPackageAmount: data.expenses.package?.amount
                        ? Math.round(data.expenses.package.amount * 100)
                        : null,
                    expensesTotalExpenses: Math.round(data.expenses.totalExpenses * 100),
                    totalHT: Math.round(data.totals.ht * 100),
                    vatRate: Math.round(data.totals.vat.rate * 100),
                    vatAmount: Math.round(data.totals.vat.amount * 100),
                    totalTTC: Math.round(data.totals.ttc * 100),
                    otherServices: data.otherServices,
                    remarksOtherServices: data.remarks.otherServices,
                    remarksTravelExpenses: data.remarks.travelExpenses,
                    remarksExpenses: data.remarks.expenses,
                    remarksThirdPartyExpenses: data.remarks.thirdPartyExpenses,
                    createdAt: new Date(),
                    updatedAt: new Date(),
                })
                .returning()

            // Create rates
            if (data.fees.rates.length > 0) {
                await tx.insert(invoiceRates).values(
                    data.fees.rates.map((rate) => ({
                        invoiceId: invoice.id,
                        rateClass: rate.rateClass,
                        baseMinutes: Math.round(rate.base * 60), // Convert hours to minutes
                        adjustedMinutes: Math.round(rate.adjusted * 60),
                        hourlyRate: Math.round(rate.hourlyRate * 100),
                        amount: Math.round(rate.amount * 100),
                        createdAt: new Date(),
                        updatedAt: new Date(),
                    }))
                )
            }

            // Create offers
            if (data.offers.length > 0) {
                await tx.insert(invoiceOffers).values(
                    data.offers.map((offer) => ({
                        invoiceId: invoice.id,
                        file: offer.file,
                        date: offer.date,
                        amount: Math.round(offer.amount * 100),
                        remark: offer.remark,
                        updatedAt: new Date(),
                    }))
                )
            }

            // Create adjudications
            if (data.adjudications.length > 0) {
                await tx.insert(invoiceAdjudications).values(
                    data.adjudications.map((adj) => ({
                        invoiceId: invoice.id,
                        file: adj.file,
                        date: adj.date,
                        amount: Math.round(adj.amount * 100),
                        remark: adj.remark,
                        createdAt: new Date(),
                        updatedAt: new Date(),
                    }))
                )
            }

            // Return the created invoice
            return this.findById(invoice.id, user)
        })
    },

    async update(id: number, data: Partial<InvoiceUpdateInput>, user: User) {
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

            // Map nested fields to flat structure
            if (data.invoiceNumber !== undefined) updateData.invoiceNumber = data.invoiceNumber
            if (data.reference !== undefined) updateData.reference = data.reference
            if (data.type !== undefined) updateData.type = data.type
            if (data.billingMode !== undefined) updateData.billingMode = data.billingMode
            if (data.status !== undefined) updateData.status = data.status
            if (data.issueDate !== undefined) updateData.issueDate = data.issueDate
            if (data.dueDate !== undefined) updateData.dueDate = data.dueDate
            if (data.description !== undefined) updateData.description = data.description
            if (data.otherServices !== undefined) updateData.otherServices = data.otherServices

            if (data.period) {
                if (data.period.startDate !== undefined)
                    updateData.periodStart = data.period.startDate
                if (data.period.endDate !== undefined) updateData.periodEnd = data.period.endDate
            }

            if (data.client?.id !== undefined) updateData.clientId = data.client.id

            if (data.recipient) {
                if (data.recipient.name !== undefined)
                    updateData.recipientName = data.recipient.name
                if (data.recipient.address !== undefined)
                    updateData.recipientAddress = data.recipient.address
            }

            if (data.fees) {
                if (data.fees.base !== undefined)
                    updateData.feesBase = Math.round(data.fees.base * 100)
                if (data.fees.adjusted !== undefined)
                    updateData.feesAdjusted = Math.round(data.fees.adjusted * 100)
                if (data.fees.total !== undefined)
                    updateData.feesTotal = Math.round(data.fees.total * 100)
                if (data.fees.others !== undefined)
                    updateData.feesOthers = Math.round(data.fees.others * 100)
                if (data.fees.finalTotal !== undefined)
                    updateData.feesFinalTotal = Math.round(data.fees.finalTotal * 100)
                if (data.fees.multiplicationFactor !== undefined)
                    updateData.feesMultiplicationFactor = Math.round(
                        data.fees.multiplicationFactor * 100
                    )
                if (data.fees.discount) {
                    updateData.feesDiscountPercentage = data.fees.discount.percentage
                        ? Math.round(data.fees.discount.percentage * 100)
                        : null
                    updateData.feesDiscountAmount = data.fees.discount.amount
                        ? Math.round(data.fees.discount.amount * 100)
                        : null
                }

                // Update rates if provided
                if (data.fees.rates) {
                    // Delete existing rates
                    await tx.delete(invoiceRates).where(eq(invoiceRates.invoiceId, id))
                    // Insert new rates
                    if (data.fees.rates.length > 0) {
                        await tx.insert(invoiceRates).values(
                            data.fees.rates.map((rate) => ({
                                invoiceId: id,
                                rateClass: rate.rateClass,
                                baseMinutes: Math.round(rate.base * 60),
                                adjustedMinutes: Math.round(rate.adjusted * 60),
                                hourlyRate: Math.round(rate.hourlyRate * 100),
                                amount: Math.round(rate.amount * 100),
                                createdAt: new Date(),
                                updatedAt: new Date(),
                            }))
                        )
                    }
                }
            }

            if (data.expenses) {
                if (data.expenses.travel) {
                    if (data.expenses.travel.base !== undefined)
                        updateData.expensesTravelBase = Math.round(data.expenses.travel.base * 100)
                    if (data.expenses.travel.adjusted !== undefined)
                        updateData.expensesTravelAdjusted = Math.round(
                            data.expenses.travel.adjusted * 100
                        )
                    if (data.expenses.travel.rate !== undefined)
                        updateData.expensesTravelRate = Math.round(data.expenses.travel.rate * 100)
                    if (data.expenses.travel.amount !== undefined)
                        updateData.expensesTravelAmount = Math.round(
                            data.expenses.travel.amount * 100
                        )
                }
                if (data.expenses.other) {
                    if (data.expenses.other.base !== undefined)
                        updateData.expensesOtherBase = Math.round(data.expenses.other.base * 100)
                    if (data.expenses.other.amount !== undefined)
                        updateData.expensesOtherAmount = Math.round(
                            data.expenses.other.amount * 100
                        )
                }
                if (data.expenses.total !== undefined)
                    updateData.expensesTotal = Math.round(data.expenses.total * 100)
                if (data.expenses.thirdParty?.amount !== undefined)
                    updateData.expensesThirdPartyAmount = Math.round(
                        data.expenses.thirdParty.amount * 100
                    )
                if (data.expenses.package) {
                    updateData.expensesPackagePercentage = data.expenses.package.percentage
                        ? Math.round(data.expenses.package.percentage * 100)
                        : null
                    updateData.expensesPackageAmount = data.expenses.package.amount
                        ? Math.round(data.expenses.package.amount * 100)
                        : null
                }
                if (data.expenses.totalExpenses !== undefined)
                    updateData.expensesTotalExpenses = Math.round(data.expenses.totalExpenses * 100)
            }

            if (data.totals) {
                if (data.totals.ht !== undefined)
                    updateData.totalHT = Math.round(data.totals.ht * 100)
                if (data.totals.vat) {
                    if (data.totals.vat.rate !== undefined)
                        updateData.vatRate = Math.round(data.totals.vat.rate * 100)
                    if (data.totals.vat.amount !== undefined)
                        updateData.vatAmount = Math.round(data.totals.vat.amount * 100)
                }
                if (data.totals.ttc !== undefined)
                    updateData.totalTTC = Math.round(data.totals.ttc * 100)
            }

            if (data.remarks) {
                if (data.remarks.otherServices !== undefined)
                    updateData.remarksOtherServices = data.remarks.otherServices
                if (data.remarks.travelExpenses !== undefined)
                    updateData.remarksTravelExpenses = data.remarks.travelExpenses
                if (data.remarks.expenses !== undefined)
                    updateData.remarksExpenses = data.remarks.expenses
                if (data.remarks.thirdPartyExpenses !== undefined)
                    updateData.remarksThirdPartyExpenses = data.remarks.thirdPartyExpenses
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
                            date: offer.date,
                            amount: Math.round(offer.amount * 100),
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
                            date: adj.date,
                            amount: Math.round(adj.amount * 100),
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

    async delete(id: number, user: User) {
        const existing = await this.findById(id, user)
        if (!existing) {
            return false
        }

        await db.delete(invoices).where(eq(invoices.id, id))
        return true
    },
}
