<template>
    <div class="mb-6">
        <h1 class="text-2xl font-bold">
            {{ isNewActivityType ? "Nouveau type d'activité" : "Modifier type d'activité" }}
        </h1>
    </div>

    <Card>
        <form @submit.prevent="saveActivityType">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <label for="name" class="block text-sm font-medium text-gray-700 mb-1">
                        Nom
                    </label>
                    <input
                        type="text"
                        id="name"
                        v-model="activityType.name"
                        class="w-full p-2 border border-gray-300 rounded-md"
                        required
                    />
                </div>

                <div>
                    <label for="code" class="block text-sm font-medium text-gray-700 mb-1">
                        Code
                    </label>
                    <input
                        type="text"
                        id="code"
                        v-model="activityType.code"
                        class="w-full p-2 border border-gray-300 rounded-md"
                        required
                    />
                </div>

                <div>
                    <label class="flex items-center">
                        <input type="checkbox" v-model="activityType.billable" class="mr-2" />
                        <span class="text-sm font-medium text-gray-700">Facturable</span>
                    </label>
                </div>
            </div>

            <div class="flex justify-end space-x-3 mt-6">
                <Button type="button" variant="ghost" :to="{ name: 'activity-list' }">
                    Annuler
                </Button>
                <Button type="submit" variant="primary" :loading="loadingCreate || loadingUpdate">
                    {{ isNewActivityType ? "Créer" : "Modifier" }}
                </Button>
            </div>
        </form>
    </Card>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from "vue"
import { useRoute, useRouter } from "vue-router"
import Button from "../../components/atoms/Button.vue"
import {
    useFetchActivityType,
    useCreateActivityType,
    useUpdateActivityType,
} from "../../composables/api/useActivityType"
import type { ActivityTypeCreateInput, ActivityTypeUpdateInput } from "@beg/validations"
import Card from "@/components/atoms/Card.vue"

const route = useRoute()
const router = useRouter()
const activityTypeId = computed(() =>
    route.params.id ? parseInt(route.params.id as string) : null
)
const isNewActivityType = computed(() => !activityTypeId.value)

// API composables
const { get: getActivityType, data: activityTypeData } = useFetchActivityType()
const { post: createActivityType, loading: loadingCreate } = useCreateActivityType()
const { put: updateActivityType, loading: loadingUpdate } = useUpdateActivityType()

// Form data
const activityType = ref<ActivityTypeCreateInput | ActivityTypeUpdateInput>({
    name: "",
    code: "",
    billable: false,
})

// Load activity type data if editing
onMounted(async () => {
    if (activityTypeId.value) {
        await getActivityType({ params: { id: activityTypeId.value } })

        if (activityTypeData.value) {
            activityType.value = {
                name: activityTypeData.value.name,
                code: activityTypeData.value.code,
                billable: activityTypeData.value.billable,
            }
        }
    }
})

const saveActivityType = async () => {
    try {
        if (isNewActivityType.value) {
            await createActivityType({ body: activityType.value as ActivityTypeCreateInput })
        } else if (activityTypeData.value?.id) {
            await updateActivityType({
                body: activityType.value as ActivityTypeUpdateInput,
                params: { id: activityTypeId.value! },
            })
        }

        // Redirect to the list page
        router.push({ name: "activity-list" })
    } catch (error) {
        console.error("Error saving activity type:", error)
    }
}
</script>
