<template>
  <header class="fixed top-0 left-0 right-0 z-50 px-6 py-4 bg-garden-cream/85 backdrop-blur-xl border-b border-soil-pale">
    <div class="max-w-7xl mx-auto flex items-center justify-between">
      <!-- Logo -->
      <router-link to="/grades" class="flex items-center gap-2 no-underline">
        <div class="w-10 h-10 rounded-full flex items-center justify-center text-xl"
             style="background: linear-gradient(135deg, #66BB6A 0%, #43A047 100%);">
          🌱
        </div>
        <span class="font-display font-bold text-xl text-soil-dark">LearnWithAI</span>
      </router-link>

      <!-- Garden Path Navigation -->
      <nav class="hidden md:flex items-center gap-2 px-4 py-2 bg-garden-paper rounded-full text-sm">
        <router-link
          v-for="step in pathSteps"
          :key="step.name"
          :to="step.to"
          :class="[
            'transition-colors',
            step.active ? 'text-flourish font-semibold' : 'text-soil-light hover:text-soil-medium'
          ]"
        >
          {{ step.name }}
        </router-link>
        <span v-if="pathSteps.length > 0" class="text-sprout">🌿</span>
      </nav>

      <!-- User Menu -->
      <div class="flex items-center gap-4">
        <div
          class="w-11 h-11 rounded-full flex items-center justify-center font-bold text-soil-dark cursor-pointer transition-transform hover:scale-110"
          style="background: linear-gradient(135deg, #F8BBD9, #F48FB1);"
          :title="userStore.user?.full_name || 'Profile'"
        >
          {{ userInitials }}
        </div>
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useRoute } from 'vue-router';
import { useUserStore } from '@/stores/user';

const route = useRoute();
const userStore = useUserStore();

const userInitials = computed(() => {
  const name = userStore.user?.full_name || userStore.user?.email || 'U';
  return name.charAt(0).toUpperCase();
});

const pathSteps = computed(() => {
  const steps = [];
  if (route.name === 'grades') {
    steps.push({ name: 'Grades', to: '/grades', active: true });
  } else if (route.name === 'subjects') {
    steps.push(
      { name: 'Grades', to: '/grades', active: false },
      { name: 'Subjects', to: route.path, active: true }
    );
  } else if (route.name === 'topics') {
    steps.push(
      { name: 'Grades', to: '/grades', active: false },
      { name: 'Subjects', to: `/subjects/${route.params.subjectId}`, active: false },
      { name: 'Topics', to: route.path, active: true }
    );
  }
  return steps;
});
</script>
