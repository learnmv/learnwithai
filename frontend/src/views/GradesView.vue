<template>
  <div class="min-h-screen py-20 px-4">
    <div class="max-w-4xl mx-auto">
      <!-- Hero Section -->
      <div class="text-center mb-16">
        <h1 class="font-display text-5xl md:text-6xl font-bold text-soil-dark mb-4">
          Welcome to your
          <span class="block text-gradient">Learning Garden</span>
        </h1>
        <p class="text-lg text-soil-medium max-w-2xl mx-auto">
          Choose your grade to begin cultivating knowledge. Each subject is a unique biome waiting to be explored.
        </p>
      </div>

      <!-- Grades Grid -->
      <div v-if="loading" class="text-center py-12">
        <div class="text-4xl animate-spin">🌱</div>
        <p class="mt-4 text-soil-medium">Loading grades...</p>
      </div>

      <div v-else class="grid grid-cols-2 md:grid-cols-4 gap-6">
        <div
          v-for="grade in grades"
          :key="grade.id"
          class="card cursor-pointer text-center relative overflow-hidden group"
          :class="{ 'ring-2 ring-flourish bg-seed': selectedGrade === grade.id }"
          @click="selectGrade(grade.id)"
        >
          <!-- Active indicator -->
          <div
            v-if="grade.id === 6"
            class="absolute top-3 right-3 w-3 h-3 bg-sapling rounded-full animate-pulse"
          />

          <!-- Hover effect -->
          <div class="absolute inset-0 bg-seed opacity-0 group-hover:opacity-100 transition-opacity duration-300 -z-10" />

          <div class="font-mono text-5xl font-bold text-soil-dark mb-2 relative z-10">
            {{ grade.level }}
          </div>
          <div class="text-sm text-soil-medium uppercase tracking-widest relative z-10">
            Grade
          </div>
        </div>
      </div>

      <!-- Continue Button -->
      <div v-if="selectedGrade" class="text-center mt-12">
        <Button @click="goToSubjects">
          Continue →
        </Button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useApi } from '@/composables/useApi';
import Button from '@/components/common/Button.vue';
import type { Grade } from '@/types';

const api = useApi();
const router = useRouter();

const grades = ref<Grade[]>([]);
const selectedGrade = ref<number | null>(null);
const loading = ref(true);

onMounted(async () => {
  try {
    const response = await api.getGrades();
    grades.value = response.data;
  } catch (error) {
    console.error('Failed to load grades:', error);
  } finally {
    loading.value = false;
  }
});

function selectGrade(gradeId: number) {
  selectedGrade.value = gradeId;
}

function goToSubjects() {
  if (selectedGrade.value) {
    router.push(`/subjects/${selectedGrade.value}`);
  }
}
</script>
