<template>
  <div class="min-h-screen py-20 px-4">
    <div class="max-w-6xl mx-auto">
      <!-- Header -->
      <div class="text-center mb-12">
        <h1 class="font-display text-4xl md:text-5xl font-bold text-soil-dark mb-4">
          Grade <span class="text-gradient">{{ gradeId }}</span>
        </h1>
        <p class="text-lg text-soil-medium">
          Select a subject to explore its learning ecosystem
        </p>
      </div>

      <!-- Back Button -->
      <div class="mb-8">
        <Button variant="secondary" @click="$router.push('/grades')">
          ← Back to Grades
        </Button>
      </div>

      <!-- Subjects Grid -->
      <div v-if="loading" class="text-center py-12">
        <div class="text-4xl animate-spin">🌱</div>
        <p class="mt-4 text-soil-medium">Loading subjects...</p>
      </div>

      <div v-else class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div
          v-for="subject in subjects"
          :key="subject.id"
          class="card cursor-pointer group"
          @click="goToTopics(subject.id)"
        >
          <div class="flex items-start gap-4">
            <!-- Subject Icon -->
            <div
              class="w-16 h-16 rounded-2xl flex items-center justify-center text-3xl flex-shrink-0"
              :style="{ backgroundColor: getSubjectColor(subject.color_theme) }"
            >
              {{ subject.icon }}
            </div>

            <div class="flex-1">
              <h3 class="font-display text-2xl font-semibold mb-2">
                {{ subject.name }}
              </h3>
              <p class="text-soil-medium mb-4">{{ subject.description }}</p>

              <!-- Progress Bar -->
              <div class="flex items-center gap-3">
                <div class="flex-1 h-2 bg-soil-pale rounded-full overflow-hidden">
                  <div
                    class="h-full rounded-full transition-all duration-500"
                    :style="{
                      width: `${subject.progress_percentage}%`,
                      background: `linear-gradient(90deg, ${getSubjectAccent(subject.color_theme)}, #66BB6A)`
                    }"
                  />
                </div>
                <span class="font-mono text-sm text-soil-medium">
                  {{ subject.progress_percentage }}%
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useApi } from '@/composables/useApi';
import Button from '@/components/common/Button.vue';
import type { Subject } from '@/types';

const api = useApi();
const route = useRoute();
const router = useRouter();

const gradeId = ref(Number(route.params.gradeId));
const subjects = ref<Subject[]>([]);
const loading = ref(true);

const subjectColors: Record<string, string> = {
  math: '#F5E6C8',
  science: '#C8E6C9',
  english: '#BBDEFB',
  history: '#FFE0B2',
};

const subjectAccents: Record<string, string> = {
  math: '#FFB74D',
  science: '#43A047',
  english: '#42A5F5',
  history: '#FFA726',
};

onMounted(async () => {
  try {
    const response = await api.getSubjectsByGrade(gradeId.value);
    subjects.value = response.data;
  } catch (error) {
    console.error('Failed to load subjects:', error);
  } finally {
    loading.value = false;
  }
});

function getSubjectColor(theme?: string): string {
  return subjectColors[theme || 'math'];
}

function getSubjectAccent(theme?: string): string {
  return subjectAccents[theme || 'math'];
}

function goToTopics(subjectId: number) {
  router.push(`/topics/${subjectId}`);
}
</script>
