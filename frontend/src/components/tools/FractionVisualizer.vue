<template>
  <div ref="container" class="flex flex-col items-center">
    <div class="flex flex-wrap gap-2 mb-4 justify-center">
      <div
        v-for="i in denominator"
        :key="i"
        class="w-10 h-10 rounded transition-all duration-300"
        :style="{ backgroundColor: i <= numerator ? '#43A047' : '#D4C4B0' }"
      />
    </div>
    <p class="font-mono text-lg font-bold text-soil-dark">
      {{ numerator }}/{{ denominator }}
    </p>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';

const numerator = ref(2);
const denominator = ref(4);

onMounted(() => {
  // Animate the fraction
  setTimeout(() => {
    numerator.value = 3;
  }, 1000);
});
</script>
