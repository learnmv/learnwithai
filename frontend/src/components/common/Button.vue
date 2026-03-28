<template>
  <button
    :class="[
      'inline-flex items-center justify-center gap-2 px-7 py-3.5 font-body font-semibold rounded-full transition-all duration-300',
      variant === 'primary'
        ? 'text-white btn-primary-gradient hover:-translate-y-0.5 hover:scale-[1.02]'
        : 'text-soil-dark bg-white border-2 border-soil-pale hover:border-sapling hover:text-flourish hover:-translate-y-0.5'
    ]"
    :disabled="disabled || loading"
  >
    <span v-if="loading" class="animate-spin">⟳</span>
    <slot />
  </button>
</template>

<script setup lang="ts">
interface Props {
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
  loading?: boolean;
}

withDefaults(defineProps<Props>(), {
  variant: 'primary',
  disabled: false,
  loading: false,
});
</script>

<style scoped>
.btn-primary-gradient {
  background: linear-gradient(135deg, #66BB6A 0%, #43A047 100%);
  box-shadow: 0 4px 16px rgba(67, 160, 71, 0.35);
}

.btn-primary-gradient:hover {
  box-shadow: 0 8px 24px rgba(67, 160, 71, 0.45);
}
</style>
