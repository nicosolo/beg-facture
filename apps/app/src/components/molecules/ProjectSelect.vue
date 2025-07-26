<template>
    <div class="relative">
        <input
            v-model="searchTerm"
            :placeholder="placeholder || $t('common.search')"
            :disabled="disabled"
            @input="handleInput"
            @focus="showDropdown = true"
            @blur="handleBlur"
            @keydown="handleKeyDown"
            :ref="(el) => (inputRef = el as HTMLInputElement)"
            :class="[
                'w-full px-3 py-2 border rounded-md outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500',
                disabled ? 'bg-gray-100 cursor-not-allowed' : 'bg-white',
            ]"
        />

        <!-- Loading spinner -->
        <div v-if="loading" class="absolute right-2 top-1/2 transform -translate-y-1/2">
            <LoadingSpinner size="md" color="gray" />
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
                {{ $t("common.noResults") }}
            </div>

            <!-- Type to search message -->
            <div
                v-else-if="searchTerm.length < 2 && !selectedProjectName"
                class="px-3 py-2 text-gray-500"
            >
                {{ $t("projects.typeToSearch") }}
            </div>

            <!-- Project options -->
            <button
                v-for="(project, index) in projects"
                :key="project.id"
                @mousedown.prevent="selectProject(project)"
                @mouseenter="focusedIndex = index"
                :class="[
                    'w-full px-3 py-2 text-left focus:outline-none',
                    focusedIndex === index ? 'bg-gray-100' : 'hover:bg-gray-100',
                ]"
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
import LoadingSpinner from "@/components/atoms/LoadingSpinner.vue"
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
const focusedIndex = ref(0)

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
                limit: 30,
                includeArchived: false,
                includeEnded: false,
            },
        })
        if (response) {
            projects.value = response.data
            focusedIndex.value = 0 // Reset focus to first item
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
    focusedIndex.value = 0
    debouncedSearch(searchTerm.value)
}

// Handle keyboard navigation
const handleKeyDown = (event: KeyboardEvent) => {
    switch (event.key) {
        case "ArrowDown":
            event.preventDefault()
            if (!showDropdown.value && searchTerm.value.length >= 2) {
                showDropdown.value = true
            } else if (projects.value.length > 0) {
                focusedIndex.value = Math.min(focusedIndex.value + 1, projects.value.length - 1)
            }
            break
        case "ArrowUp":
            event.preventDefault()
            if (showDropdown.value && projects.value.length > 0) {
                focusedIndex.value = Math.max(focusedIndex.value - 1, 0)
            }
            break
        case "Enter":
            event.preventDefault()
            if (showDropdown.value && projects.value[focusedIndex.value]) {
                selectProject(projects.value[focusedIndex.value])
            }
            break
        case "Escape":
            event.preventDefault()
            if (showDropdown.value) {
                showDropdown.value = false
                focusedIndex.value = 0
            }
            break
    }
}

// Handle blur
const handleBlur = () => {
    // Delay to allow click on dropdown items
    setTimeout(() => {
        showDropdown.value = false
        focusedIndex.value = 0
    }, 200)
}

// Select project
const selectProject = (project: ProjectResponse) => {
    selectedProjectName.value = `${project.projectNumber} - ${project.name}`
    console.log("selectedProjectName", selectedProjectName.value)
    searchTerm.value = selectedProjectName.value
    emit("update:modelValue", project.id)
    console.log("inputRef", inputRef.value)
    inputRef.value?.blur()
    showDropdown.value = false
    projects.value = []
    focusedIndex.value = 0
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
        console.log("newValue", newValue)
        if (!newValue) {
            selectedProjectName.value = ""
            projects.value = []
        }
    }
)

onMounted(() => {
    loadInitialProject()
})
</script>
