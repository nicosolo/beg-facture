<template>
    <div class="container mx-auto">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold">{{ $t("invoice.title") }}</h1>
            <Button variant="primary" :to="{ name: 'invoice-new' }">
                {{ $t("invoice.new") }}
            </Button>
        </div>

        <InvoiceListManager 
            :hide-header="true"
            :show-delete="false"
        />
    </div>
</template>

<script setup lang="ts">
import { onMounted } from "vue"
import Button from "@/components/atoms/Button.vue"
import InvoiceListManager from "@/components/organisms/invoice/InvoiceListManager.vue"

onMounted(() => {
    document.title = "BEG - Liste des factures"
})
</script>
