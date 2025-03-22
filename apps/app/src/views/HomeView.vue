<template>
    <main>
        {{ activities }}
        <TheWelcome />
    </main>
</template>
<script setup lang="ts">
import { useActivityAPI } from "@/composables/api/useFetchActivity"
import TheWelcome from "@/components/TheWelcome.vue"

const { data: activities, get } = useActivityAPI()
get({
    page: 1,
    limit: 10,
    projectId: 206,
})
</script>
