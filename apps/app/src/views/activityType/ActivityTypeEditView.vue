<template>
    <FormLayout
        :title="isNewActivityType ? 'Nouveau type d\'activité' : 'Modifier type d\'activité'"
        :loading="loadingCreate || loadingUpdate"
        :error-message="errorMessage"
    >
        <form @submit.prevent="saveActivityType" id="activityTypeForm">
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

        </form>

        <template #actions>
            <Button type="button" variant="secondary" :to="{ name: 'activity-list' }">
                Annuler
            </Button>
            <Button type="submit" form="activityTypeForm" variant="primary" :loading="loadingCreate || loadingUpdate">
                {{ isNewActivityType ? "Créer" : "Modifier" }}
            </Button>
        </template>
    </FormLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from "vue"
import { useRoute, useRouter } from "vue-router"
import Button from "../../components/atoms/Button.vue"
import FormLayout from "@/components/templates/FormLayout.vue"
import {
    useFetchActivityType,
    useCreateActivityType,
    useUpdateActivityType,
} from "../../composables/api/useActivityType"
import type { ActivityTypeCreateInput, ActivityTypeUpdateInput } from "@beg/validations"

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

// Error state
const errorMessage = ref<string | null>(null)

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
    errorMessage.value = null
    
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
    } catch (error: any) {
        console.error("Error saving activity type:", error)
        errorMessage.value = error.message || "Une erreur s'est produite lors de l'enregistrement"
    }
}
</script>
