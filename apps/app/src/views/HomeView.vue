<template>
    <div class="home-view">
        <h1>Welcome to our Application</h1>
        {{ users }}
    </div>
</template>

<script setup lang="ts">
import { useAPI } from "~/composables/useAPI"

const { client, loading, error } = useAPI()

const users = await client.user.$get()
</script>
