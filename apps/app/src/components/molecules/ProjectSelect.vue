<template>
    <div class="relative">
        <input
            v-model="searchTerm"
            :placeholder="placeholder || $t('common.search')"
            :disabled="disabled"
            @input="handleInput"
            @focus="showDropdown = true"
            @blur="handleBlur"
            :ref="(el) => (inputRef = el as HTMLInputElement)"
            :class="[
                'w-full px-3 py-2 border rounded-md outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500',
                disabled ? 'bg-gray-100 cursor-not-allowed' : 'bg-white',
            ]"
        />

        <!-- Loading spinner -->
        <div v-if="loading" class="absolute right-2 top-1/2 transform -translate-y-1/2">
            <svg
                class="animate-spin h-5 w-5 text-gray-400"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
            >
                <circle
                    class="opacity-25"
                    cx="12"
                    cy="12"
                    r="10"
                    stroke="currentColor"
                    stroke-width="4"
                ></circle>
                <path
                    class="opacity-75"
                    fill="currentColor"
                    d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                ></path>
            </svg>
        </div>

        <!-- Dropdown -->
        <div
            v-if="showDropdown"
            class="absolute z-10 w-full mt-1 bg-white border border-gray-200 rounded-md shadow-lg max-h-60 overflow-auto"
        >
            <!-- No results -->
            <div
                v-if="searchTerm.length >= 2 && projects.length === 0 && !loading"
                class="px-3 py-2 text-gray-500"
            >
                {{ $t("common.noResults", "No results found") }}
            </div>

            <!-- Type to search message -->
            <div
                v-else-if="searchTerm.length < 2 && !selectedProjectName"
                class="px-3 py-2 text-gray-500"
            >
                {{ $t("projects.typeToSearch", "Type at least 2 characters to search") }}
            </div>

            <!-- Project options -->
            <button
                v-for="project in projects"
                :key="project.id"
                @mousedown.prevent="selectProject(project)"
                class="w-full px-3 py-2 text-left hover:bg-gray-100 focus:bg-gray-100 focus:outline-none"
            >
                <div class="font-medium">{{ project.projectNumber }} - {{ project.name }}</div>
                <div v-if="project.ended" class="text-sm text-gray-500">
                    {{ $t("projects.status.completed") }}
                </div>
            </button>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from "vue"
import { useFetchProjectList, useFetchProject } from "@/composables/api/useProject"
import { debounce } from "@/utils/debounce"
import type { ProjectResponse } from "@beg/validations"

interface Props {
    modelValue?: number
    placeholder?: string
    disabled?: boolean
}

const props = defineProps<Props>()

const emit = defineEmits<{
    "update:modelValue": [value: number | undefined]
}>()

// State
const searchTerm = ref("")
const showDropdown = ref(false)
const projects = ref<ProjectResponse[]>([])
const selectedProjectName = ref("")
const loading = ref(false)

// API composables
const { get: fetchProjectList } = useFetchProjectList()
const { get: fetchProject } = useFetchProject()

const inputRef = ref<HTMLInputElement>()

// Search for projects
const searchProjects = async (search: string) => {
    if (search.length < 2) {
        projects.value = []
        return
    }

    loading.value = true
    try {
        const response = await fetchProjectList({
            query: {
                name: search,
                page: 1,
                limit: 10,
                includeArchived: true,
                includeEnded: true,
            },
        })
        if (response) {
            projects.value = response.data
            // Auto-select if only one project is returned
            if (response.data.length === 1) {
                selectProject(response.data[0])
            }
        }
    } catch (error) {
        console.error("Error fetching projects:", error)
        projects.value = []
    } finally {
        loading.value = false
    }
}

// Debounced search
const debouncedSearch = debounce(searchProjects, 100)

// Handle input
const handleInput = () => {
    selectedProjectName.value = ""
    if (props.modelValue) {
        emit("update:modelValue", undefined)
    }
    debouncedSearch(searchTerm.value)
}

// Handle blur
const handleBlur = () => {
    // Delay to allow click on dropdown items
    setTimeout(() => {
        showDropdown.value = false
    }, 200)
}

// Select project
const selectProject = (project: ProjectResponse) => {
    selectedProjectName.value = `${project.projectNumber} - ${project.name}`
    searchTerm.value = selectedProjectName.value
    emit("update:modelValue", project.id)
    console.log("inputRef", inputRef.value)
    inputRef.value?.blur()
    showDropdown.value = false
    projects.value = []
}

// Load initial project if modelValue is set
const loadInitialProject = async () => {
    if (props.modelValue) {
        loading.value = true
        try {
            console.log("props.modelValue", props.modelValue)
            const project = await fetchProject({
                params: { id: props.modelValue },
            })
            console.log("project", project)
            if (project) {
                selectedProjectName.value = `${project.projectNumber} - ${project.name}`
                searchTerm.value = selectedProjectName.value
            }
        } catch (error) {
            console.error("Error loading project:", error)
        } finally {
            loading.value = false
        }
    }
}

// Watch for modelValue changes
watch(
    () => props.modelValue,
    (newValue) => {
        if (!newValue) {
            searchTerm.value = ""
            selectedProjectName.value = ""
            projects.value = []
        }
    }
)

onMounted(() => {
    loadInitialProject()
})
</script>
