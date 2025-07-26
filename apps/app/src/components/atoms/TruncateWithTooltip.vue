<template>
    <div
        v-if="showTooltip && content"
        ref="tooltipWrapper"
        @mouseenter="showTooltipOnHover"
        @mouseleave="hideTooltip"
        @click="showTooltipOnHover"
    >
        <span class="truncate-text" :class="textClass">
            <slot>
                {{ content }}
            </slot>
        </span>
        <Teleport to="body" v-if="isHovering">
            <span
                class="tooltip-text"
                :class="[tooltipClass, `tooltip-${placement}`]"
                :style="tooltipPosition"
            >
                {{ content }}
                <span class="tooltip-arrow"></span>
            </span>
        </Teleport>
    </div>
    <span v-else class="truncate-text" :class="textClass">
        {{ content || "" }}
    </span>
</template>

<script setup lang="ts">
import { ref } from "vue"

interface Props {
    content?: string | null
    showTooltip?: boolean
    textClass?: string
    tooltipClass?: string
    placement?: "top" | "bottom" | "left" | "right"
}

const {
    content,
    showTooltip = true,
    textClass = "",
    tooltipClass = "",
    placement = "left",
} = defineProps<Props>()

const tooltipWrapper = ref<HTMLElement>()
const isHovering = ref(false)
const tooltipPosition = ref({
    top: "0px",
    left: "0px",
    transform: "translateY(-50%) translateX(-100%)",
})

const showTooltipOnHover = () => {
    if (!tooltipWrapper.value) return

    const rect = tooltipWrapper.value.getBoundingClientRect()
    const spacing = 8

    // Calculate position based on placement
    let position = { top: "0px", left: "0px", transform: "" }

    switch (placement) {
        case "top":
            position = {
                top: `${rect.top - spacing}px`,
                left: `${rect.left + rect.width / 2}px`,
                transform: "translateX(-50%) translateY(-100%)",
            }
            break
        case "bottom":
            position = {
                top: `${rect.bottom + spacing}px`,
                left: `${rect.left + rect.width / 2}px`,
                transform: "translateX(-50%)",
            }
            break
        case "left":
            position = {
                top: `${rect.top + rect.height / 2}px`,
                left: `${rect.left - spacing}px`,
                transform: "translateY(-50%) translateX(-100%)",
            }
            break
        case "right":
            position = {
                top: `${rect.top + rect.height / 2}px`,
                left: `${rect.right + spacing}px`,
                transform: "translateY(-50%)",
            }
            break
    }

    tooltipPosition.value = position
    isHovering.value = true
}

const hideTooltip = () => {
    isHovering.value = false
}
</script>

<style scoped>
/* Truncated text */
.truncate-text {
    display: block;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

/* Tooltip text - now using fixed positioning via Teleport */
.tooltip-text {
    position: fixed;
    background-color: #374151; /* gray-700 */
    color: #fff;
    text-align: left;
    border-radius: 6px;
    padding: 5px 10px;
    z-index: 9999;
    font-size: 0.875rem; /* text-sm */
    box-shadow:
        0 4px 6px -1px rgba(0, 0, 0, 0.1),
        0 2px 4px -1px rgba(0, 0, 0, 0.06);
    pointer-events: none;
    max-width: min(300px, 50vw);
}

/* Tooltip arrow base */
.tooltip-arrow {
    position: absolute;
    width: 0;
    height: 0;
    border-style: solid;
}

/* Arrow for left placement (pointing right) */
.tooltip-left .tooltip-arrow {
    left: 100%;
    top: 50%;
    transform: translateY(-50%);
    border-width: 5px 0 5px 5px;
    border-color: transparent transparent transparent #374151;
}

/* Arrow for right placement (pointing left) */
.tooltip-right .tooltip-arrow {
    right: 100%;
    top: 50%;
    transform: translateY(-50%);
    border-width: 5px 5px 5px 0;
    border-color: transparent #374151 transparent transparent;
}

/* Arrow for top placement (pointing down) */
.tooltip-top .tooltip-arrow {
    top: 100%;
    left: 50%;
    transform: translateX(-50%);
    border-width: 5px 5px 0 5px;
    border-color: #374151 transparent transparent transparent;
}

/* Arrow for bottom placement (pointing up) */
.tooltip-bottom .tooltip-arrow {
    bottom: 100%;
    left: 50%;
    transform: translateX(-50%);
    border-width: 0 5px 5px 5px;
    border-color: transparent transparent #374151 transparent;
}

/* Allow text wrapping for very long content */
.tooltip-text.long-text {
    white-space: normal;
    word-break: break-word;
}
</style>
