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
import type { InvoiceCreateInput, InvoiceUpdateInput, InvoiceFilter } from "@beg/validations"
import { projectRepository } from "./project.repository"
import type { Variables } from "@src/types/global"

export const invoiceRepository = {
    async findAll(user: Variables["user"], filter: InvoiceFilter) {
        const where = []

        // Access control
        if (user.role !== "admin") {
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
                        amount: o.amount,
                        remark: o.remark || "",
                    })),
                    adjudications: adjudications.map((a) => ({
                        file: a.file,
                        date: a.date,
                        amount: a.amount,
                        remark: a.remark || "",
                    })),
                    fees: {
                        base: row.invoice.feesBase,
                        adjusted: row.invoice.feesAdjusted,
                        total: row.invoice.feesTotal,
                        others: row.invoice.feesOthers,
                        finalTotal: row.invoice.feesFinalTotal,
                        multiplicationFactor: row.invoice.feesMultiplicationFactor,
                        discount: {
                            percentage: row.invoice.feesDiscountPercentage,
                            amount: row.invoice.feesDiscountAmount,
                        },
                        rates: rates.map((r) => ({
                            rateClass: r.rateClass,
                            base: r.baseMinutes / 60, // Convert minutes to hours
                            adjusted: r.adjustedMinutes / 60,
                            hourlyRate: r.hourlyRate,
                            amount: r.amount,
                        })),
                    },
                    expenses: {
                        travel: {
                            base: row.invoice.expensesTravelBase,
                            adjusted: row.invoice.expensesTravelAdjusted,
                            rate: row.invoice.expensesTravelRate,
                            amount: row.invoice.expensesTravelAmount,
                        },
                        other: {
                            base: row.invoice.expensesOtherBase,
                            amount: row.invoice.expensesOtherAmount,
                        },
                        total: row.invoice.expensesTotal,
                        thirdParty: {
                            amount: row.invoice.expensesThirdPartyAmount,
                        },
                        package: {
                            percentage: row.invoice.expensesPackagePercentage,
                            amount: row.invoice.expensesPackageAmount,
                        },
                        totalExpenses: row.invoice.expensesTotalExpenses,
                    },
                    totals: {
                        ht: row.invoice.totalHT,
                        vat: {
                            rate: row.invoice.vatRate,
                            amount: row.invoice.vatAmount,
                        },
                        ttc: row.invoice.totalTTC,
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

    async findById(id: number, user: Variables["user"]) {
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
                amount: o.amount,
                remark: o.remark || "",
            })),
            adjudications: adjudications.map((a) => ({
                file: a.file,
                date: a.date,
                amount: a.amount,
                remark: a.remark || "",
            })),
            fees: {
                base: row.invoice.feesBase,
                adjusted: row.invoice.feesAdjusted,
                total: row.invoice.feesTotal,
                others: row.invoice.feesOthers,
                finalTotal: row.invoice.feesFinalTotal,
                multiplicationFactor: row.invoice.feesMultiplicationFactor,
                discount: {
                    percentage: row.invoice.feesDiscountPercentage,
                    amount: row.invoice.feesDiscountAmount,
                },
                rates: rates.map((r) => ({
                    rateClass: r.rateClass,
                    base: r.baseMinutes / 60,
                    adjusted: r.adjustedMinutes / 60,
                    hourlyRate: r.hourlyRate,
                    amount: r.amount,
                })),
            },
            expenses: {
                travel: {
                    base: row.invoice.expensesTravelBase,
                    adjusted: row.invoice.expensesTravelAdjusted,
                    rate: row.invoice.expensesTravelRate,
                    amount: row.invoice.expensesTravelAmount,
                },
                other: {
                    base: row.invoice.expensesOtherBase,
                    amount: row.invoice.expensesOtherAmount,
                },
                total: row.invoice.expensesTotal,
                thirdParty: {
                    amount: row.invoice.expensesThirdPartyAmount,
                },
                package: {
                    percentage: row.invoice.expensesPackagePercentage,
                    amount: row.invoice.expensesPackageAmount,
                },
                totalExpenses: row.invoice.expensesTotalExpenses,
            },
            totals: {
                ht: row.invoice.totalHT,
                vat: {
                    rate: row.invoice.vatRate,
                    amount: row.invoice.vatAmount,
                },
                ttc: row.invoice.totalTTC,
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
                    // Store real values directly
                    feesBase: data.fees.base,
                    feesAdjusted: data.fees.adjusted,
                    feesTotal: data.fees.total,
                    feesOthers: data.fees.others,
                    feesFinalTotal: data.fees.finalTotal,
                    feesMultiplicationFactor: data.fees.multiplicationFactor,
                    feesDiscountPercentage: data.fees.discount?.percentage || null,
                    feesDiscountAmount: data.fees.discount?.amount || null,
                    expensesTravelBase: data.expenses.travel.base,
                    expensesTravelAdjusted: data.expenses.travel.adjusted,
                    expensesTravelRate: data.expenses.travel.rate,
                    expensesTravelAmount: data.expenses.travel.amount,
                    expensesOtherBase: data.expenses.other.base,
                    expensesOtherAmount: data.expenses.other.amount,
                    expensesTotal: data.expenses.total,
                    expensesThirdPartyAmount: data.expenses.thirdParty.amount,
                    expensesPackagePercentage: data.expenses.package?.percentage || null,
                    expensesPackageAmount: data.expenses.package?.amount || null,
                    expensesTotalExpenses: data.expenses.totalExpenses,
                    totalHT: data.totals.ht,
                    vatRate: data.totals.vat.rate,
                    vatAmount: data.totals.vat.amount,
                    totalTTC: data.totals.ttc,
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
                        hourlyRate: rate.hourlyRate,
                        amount: rate.amount,
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
                        date: offer.date || new Date(),
                        amount: offer.amount,
                        remark: offer.remark,
                        createdAt: new Date(),
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
                        date: adj.date || new Date(),
                        amount: adj.amount,
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
                if (data.fees.base !== undefined) updateData.feesBase = data.fees.base
                if (data.fees.adjusted !== undefined) updateData.feesAdjusted = data.fees.adjusted
                if (data.fees.total !== undefined) updateData.feesTotal = data.fees.total
                if (data.fees.others !== undefined) updateData.feesOthers = data.fees.others
                if (data.fees.finalTotal !== undefined)
                    updateData.feesFinalTotal = data.fees.finalTotal
                if (data.fees.multiplicationFactor !== undefined)
                    updateData.feesMultiplicationFactor = data.fees.multiplicationFactor
                if (data.fees.discount) {
                    updateData.feesDiscountPercentage = data.fees.discount.percentage || null
                    updateData.feesDiscountAmount = data.fees.discount.amount || null
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
                                hourlyRate: rate.hourlyRate,
                                amount: rate.amount,
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
                        updateData.expensesTravelBase = data.expenses.travel.base
                    if (data.expenses.travel.adjusted !== undefined)
                        updateData.expensesTravelAdjusted = data.expenses.travel.adjusted
                    if (data.expenses.travel.rate !== undefined)
                        updateData.expensesTravelRate = data.expenses.travel.rate
                    if (data.expenses.travel.amount !== undefined)
                        updateData.expensesTravelAmount = data.expenses.travel.amount
                }
                if (data.expenses.other) {
                    if (data.expenses.other.base !== undefined)
                        updateData.expensesOtherBase = data.expenses.other.base
                    if (data.expenses.other.amount !== undefined)
                        updateData.expensesOtherAmount = data.expenses.other.amount
                }
                if (data.expenses.total !== undefined)
                    updateData.expensesTotal = data.expenses.total
                if (data.expenses.thirdParty?.amount !== undefined)
                    updateData.expensesThirdPartyAmount = data.expenses.thirdParty.amount
                if (data.expenses.package) {
                    updateData.expensesPackagePercentage = data.expenses.package.percentage || null
                    updateData.expensesPackageAmount = data.expenses.package.amount || null
                }
                if (data.expenses.totalExpenses !== undefined)
                    updateData.expensesTotalExpenses = data.expenses.totalExpenses
            }

            if (data.totals) {
                if (data.totals.ht !== undefined) updateData.totalHT = data.totals.ht
                if (data.totals.vat) {
                    if (data.totals.vat.rate !== undefined)
                        updateData.vatRate = data.totals.vat.rate
                    if (data.totals.vat.amount !== undefined)
                        updateData.vatAmount = data.totals.vat.amount
                }
                if (data.totals.ttc !== undefined) updateData.totalTTC = data.totals.ttc
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
}
