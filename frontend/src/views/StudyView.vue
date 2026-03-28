<template>
  <div class="min-h-screen py-20 px-4">
    <div class="max-w-4xl mx-auto">
      <!-- Back Navigation -->
      <div class="mb-6">
        <Button variant="secondary" @click="$router.back()">
          ← Back to Topics
        </Button>
      </div>

      <div v-if="loading" class="text-center py-12">
        <div class="text-4xl animate-spin">🌱</div>
        <p class="mt-4 text-soil-medium">Loading content...</p>
      </div>

      <div v-else-if="topic" class="space-y-6">
        <!-- Title -->
        <h1 class="font-display text-3xl md:text-4xl font-bold text-soil-dark">
          {{ topic.name }}
        </h1>

        <!-- Content Sections -->
        <div v-for="(section, index) in contentSections" :key="index"
             class="bg-garden-paper rounded-lg p-6"
        >
          <h2 class="font-display text-xl font-semibold text-soil-dark mb-4 pb-2 border-b-2 border-seed">
            {{ section.title }}
          </h2>
          <div class="prose text-soil-medium leading-relaxed">
            {{ section.content }}
          </div>

          <!-- Example Box -->
          <div v-if="section.example" class="mt-4 bg-seed border-l-4 border-sapling p-4 rounded-r-lg">
            <div class="text-xs uppercase tracking-wider text-flourish font-bold mb-2">
              {{ section.example.label }}
            </div>
            <p>{{ section.example.content }}</p>
          </div>
        </div>

        <!-- Practice Tool -->
        <div class="bg-garden-paper rounded-lg p-6">
          <div class="flex items-center gap-2 mb-4 font-semibold">
            🧮 Fraction Visualizer
          </div>

          <p class="text-soil-medium mb-4">Create your own fraction and see it visualized:</p>

          <div class="flex flex-wrap items-center gap-4">
            <input
              v-model.number="numerator"
              type="number"
              min="0"
              max="12"
              class="w-16 h-12 text-center font-mono border-2 border-soil-pale rounded-lg focus:border-sapling focus:outline-none"
            />
            <span class="text-2xl">/</span>

            <input
              v-model.number="denominator"
              type="number"
              min="1"
              max="12"
              class="w-16 h-12 text-center font-mono border-2 border-soil-pale rounded-lg focus:border-sapling focus:outline-none"
            />

            <Button @click="visualizeFraction">Visualize</Button>
          </div>

          <!-- Visualization -->
          <div v-if="showVisualization" class="mt-6">
            <div class="flex flex-wrap gap-2 justify-center mb-4">
              <div
                v-for="n in denominator"
                :key="n"
                class="w-10 h-10 rounded"
                :class="n <= numerator ? 'bg-flourish' : 'bg-soil-pale'"
              />
            </div>            <div class="text-center font-mono text-lg font-bold">
              {{ numerator }}/{{ denominator }}
            </div>
          </div>
        </div>

        <!-- Action Buttons -->
        <div class="flex flex-wrap gap-4">
          <Button @click="startQuiz">
            🎯 Practice Quiz
          </Button>
          <Button variant="secondary" @click="$router.back()">
            ← Back to Topics
          </Button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useApi } from '@/composables/useApi';
import Button from '@/components/common/Button.vue';
import type { Topic } from '@/types';

const api = useApi();
const route = useRoute();
const router = useRouter();

const topicId = ref(Number(route.params.topicId));
const topic = ref<Topic | null>(null);
const loading = ref(true);

// Practice tool state
const numerator = ref(2);
const denominator = ref(4);
const showVisualization = ref(false);

const contentSections = computed(() => {
  return topic.value?.content?.sections || [
    {
      title: 'What are Fractions?',
      content: 'A fraction represents a part of a whole. Imagine cutting a pizza into equal slices. If you have 3 slices out of 8 total slices, you have 3/8 of the pizza.',
      example: {
        label: 'Think About It',
        content: 'The top number (numerator) tells you how many parts you have. The bottom number (denominator) tells you how many equal parts the whole is divided into.'
      }
    },
    {
      title: 'Visual Representation',
      content: 'Understanding fractions becomes easier when you can visualize them. Below is a fraction visualizer tool to help you see how different fractions look.'
    }
  ];
});

onMounted(async () => {
  try {
    const response = await api.getTopic(topicId.value);
    topic.value = response.data;
  } catch (error) {
    console.error('Failed to load topic:', error);
  } finally {
    loading.value = false;
  }
});

function visualizeFraction() {
  if (numerator.value > denominator.value) {
    return;
  }
  showVisualization.value = true;
}

function startQuiz() {
  router.push(`/quiz/${topicId.value}`);
}
</script>
