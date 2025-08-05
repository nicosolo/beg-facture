import {
    idParamSchema,
    invoiceFilterSchema,
    invoiceCreateSchema,
    invoiceUpdateSchema,
    type InvoiceResponse,
    type InvoiceListResponse,
} from "@beg/validations"
import { useGet, usePost, usePut, useDelete } from "./useAPI"

export function useFetchInvoice() {
    return useGet<
        InvoiceResponse,
        {
            params: typeof idParamSchema
        }
    >("invoice/:id", {
        params: idParamSchema,
    })
}

export function useFetchInvoiceList() {
    return useGet<
        InvoiceListResponse,
        {
            query: typeof invoiceFilterSchema
        }
    >("invoice", {
        query: invoiceFilterSchema,
    })
}

export function useCreateInvoice() {
    return usePost<
        InvoiceResponse,
        {
            body: typeof invoiceCreateSchema
        }
    >("invoice", {
        body: invoiceCreateSchema,
    })
}

export function useUpdateInvoice() {
    return usePut<
        InvoiceResponse,
        {
            body: typeof invoiceUpdateSchema
            params: typeof idParamSchema
        }
    >("invoice/:id", {
        body: invoiceUpdateSchema,
        params: idParamSchema,
    })
}

export function useDeleteInvoice() {
    return useDelete<
        { success: boolean },
        {
            params: typeof idParamSchema
        }
    >("invoice/:id", {
        params: idParamSchema,
    })
}