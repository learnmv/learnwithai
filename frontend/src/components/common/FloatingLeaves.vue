<template>
  <div class="fixed inset-0 pointer-events-none overflow-hidden -z-10">
    <div
      v-for="(leaf, index) in leaves"
      :key="index"
      class="absolute text-2xl opacity-30"
      :style="{
        left: leaf.left,
        top: leaf.top,
        animation: `fall ${leaf.duration} linear infinite`,
        animationDelay: leaf.delay,
      }"
    >
      {{ leaf.emoji }}
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';

const leaves = ref<{ emoji: string; left: string; top: string; duration: string; delay: string }[]>([]);

const emojis = ['🍃', '🌿', '🍂', '🌱'];

onMounted(() => {
  // Generate floating leaves
  for (let i = 0; i < 8; i++) {
    leaves.value.push({
      emoji: emojis[Math.floor(Math.random() * emojis.length)],
      left: `${Math.random() * 100}%`,
      top: `-${Math.random() * 20}%`,
      duration: `${15 + Math.random() * 10}s`,
      delay: `${Math.random() * 10}s`,
    });
  }
});
</script>

<style scoped>
@keyframes fall {
  to {
    transform: translateY(120vh) rotate(360deg);
  }
}
</style>
