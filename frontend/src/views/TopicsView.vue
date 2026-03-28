<template>
  <div class="min-h-screen py-20 px-4">
    <div class="max-w-6xl mx-auto">
      <!-- Header -->
      <div class="text-center mb-12">
        <h1 class="font-display text-4xl font-bold text-soil-dark mb-2">
          {{ subjectName }}
        </h1>
        <p class="text-lg text-soil-medium">
          Explore topics and watch your knowledge bloom
        </p>
      </div>

      <!-- Back Button -->
      <div class="mb-8">
        <Button variant="secondary" @click="goBack">
          ← Back
        </Button>
      </div>

      <!-- Topics List -->
      <div v-if="loading" class="text-center py-12">
        <div class="text-4xl animate-spin">🌱</div>
        <p class="mt-4 text-soil-medium">Loading topics...</p>
      </div>

      <div v-else class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Topics Tree -->
        <div class="lg:col-span-2">
          <div class="bg-garden-paper rounded-lg p-6">
            <div class="flex items-center justify-between mb-6 pb-4 border-b-2 border-dashed border-soil-pale">
              <div class="flex items-center gap-2">
                <span class="text-2xl">🌳</span>
                <span class="font-display text-xl font-semibold">Learning Tree</span>
              </div>
              <Button @click="startStudyMode">📖 Study Mode</Button>
            </div>

            <div class="space-y-4">
              <div
                v-for="(topic, index) in topics"
                :key="topic.id"
                class="flex items-start gap-4 p-3 rounded-lg cursor-pointer transition-all duration-300 hover:bg-seed"
                :style="{ animationDelay: `${index * 0.1}s` }"
                @click="selectTopic(topic)"
              >
                <!-- Growth Stage -->
                <div
                  :class="[
                    'w-12 h-12 rounded-full flex items-center justify-center text-xl flex-shrink-0 transition-all duration-300',
                    getGrowthStageClass(topic.growth_stage)
                  ]"
                >
                  {{ getGrowthStageIcon(topic.growth_stage) }}
                </div>

                <!-- Topic Info -->
                <div class="flex-1">
                  <div class="font-semibold text-soil-dark mb-1">{{ topic.name }}</div>
                  <div class="text-sm text-soil-light">
                    {{ topic.estimated_minutes }} min • {{ getStageLabel(topic.growth_stage) }}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Sidebar -->
        <div class="space-y-6">
          <!-- AI Assistant Card -->
          <AIAssistant />

          <!-- Stats Card -->
          <div class="card">
            <h3 class="font-display text-xl mb-4">🌻 Your Garden</h3>
            <div class="space-y-3">
              <div class="flex items-center gap-3">
                <div class="w-9 h-9 rounded-full bg-sprout flex items-center justify-center text-base">💪</div>
                <div class="flex-1">
                  <div class="text-xs text-soil-medium">Strong Areas</div>
                  <div class="text-sm font-semibold">Fractions, Decimals</div>
                </div>
              </div>
              <div class="flex items-center gap-3">
                <div class="w-9 h-9 rounded-full bg-bloom-light flex items-center justify-center text-base">🌱</div>
                <div class="flex-1">
                  <div class="text-xs text-soil-medium">Growing Areas</div>
                  <div class="text-sm font-semibold">Algebra Basics</div>
                </div>
              </div>
              <div class="flex items-center gap-3">
                <div class="w-9 h-9 rounded-full bg-amber flex items-center justify-center text-base">🔥</div>
                <div class="flex-1">
                  <div class="text-xs text-soil-medium">Current Streak</div>
                  <div class="text-sm font-semibold">5 days 🔥</div>
                </div>
              </div>
            </div>
          </div>

          <!-- Master Quiz Card -->
          <div class="card text-center">
            <div class="text-5xl mb-2">🎯</div>
            <h3 class="text-lg font-semibold mb-2">Master Quiz</h3>
            <p class="text-sm text-soil-medium mb-4">
              Infinite questions that adapt to your skill level.
            </p>
            <Button @click="startMasterQuiz">Start Challenge</Button>
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
import AIAssistant from '@/components/ai/AIAssistant.vue';
import type { Topic } from '@/types';

const api = useApi();
const route = useRoute();
const router = useRouter();

const subjectId = ref(Number(route.params.subjectId));
const subjectName = ref('Mathematics');
const topics = ref<Topic[]>([]);
const loading = ref(true);
const selectedTopic = ref<Topic | null>(null);

const stageIcons: Record<string, string> = {
  seed: '🌰',
  sprout: '🌱',
  sapling: '🌿',
  bloom: '🌻',
};

const stageLabels: Record<string, string> = {
  seed: 'Ready to plant',
  sprout: 'Growing',
  sapling: 'Taking root',
  bloom: 'Mastered!',
};

onMounted(async () => {
  try {
    const response = await api.getTopicsBySubject(subjectId.value);
    topics.value = response.data;
  } catch (error) {
    console.error('Failed to load topics:', error);
  } finally {
    loading.value = false;
  }
});

function getGrowthStageClass(stage: string): string {
  const classes: Record<string, string> = {
    seed: 'bg-soil-pale',
    sprout: 'bg-sprout animate-bob',
    sapling: 'bg-sapling shadow-lg',
    bloom: 'growth-stage-bloom animate-sway',
  };
  return classes[stage] || classes.seed;
}

function getGrowthStageIcon(stage: string): string {
  return stageIcons[stage] || stageIcons.seed;
}

function getStageLabel(stage: string): string {
  return stageLabels[stage] || stageLabels.seed;
}

function selectTopic(topic: Topic) {
  selectedTopic.value = topic;
  router.push(`/study/${topic.id}`);
}

function startStudyMode() {
  if (topics.value.length > 0) {
    router.push(`/study/${topics.value[0].id}`);
  }
}

function startMasterQuiz() {
  if (selectedTopic.value) {
    router.push(`/quiz/${selectedTopic.value.id}`);
  } else if (topics.value.length > 0) {
    router.push(`/quiz/${topics.value[0].id}`);
  }
}

function goBack() {
  // Navigate back to subjects - need grade_id from subject
  router.back();
}
</script>
