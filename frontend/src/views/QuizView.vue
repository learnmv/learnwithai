<template>
  <div class="min-h-screen py-20 px-4">
    <div class="max-w-3xl mx-auto">
      <!-- Quiz Header -->
      <div class="text-center mb-8">
        <h1 class="font-display text-3xl font-bold text-soil-dark mb-2">🎯 Master Quiz</h1>
        <!-- Difficulty Indicator -->
        <div class="inline-flex items-center gap-3 bg-garden-paper px-4 py-2 rounded-full text-sm">
          <span class="text-soil-medium">Difficulty:</span>
          <div class="flex gap-1">
            <div
              v-for="n in 3"
              :key="n"
              class="w-2.5 h-2.5 rounded-full"
              :class="n <= currentDifficulty ? 'bg-flourish' : 'bg-soil-pale'"
            />
          </div>
        </div>
      </div>

      <div v-if="loading" class="text-center py-12">
        <div class="text-4xl animate-spin">🌱</div>
        <p class="mt-4 text-soil-medium">Loading quiz...</p>
      </div>

      <div v-else-if="!quizComplete &amp;&amp; currentQuestion">
        <!-- Question Card -->
        <div class="card mb-6">
          <div class="font-mono text-sm text-soil-light uppercase tracking-wider mb-4">
            Question {{ questionNumber }}
          </div>

          <p class="text-xl font-semibold text-soil-dark mb-6">
            {{ currentQuestion.question_text }}
          </p>

          <!-- Answer Options -->
          <div class="space-y-3">
            <div
              v-for="(option, index) in currentQuestion.options"
              :key="index"
              class="flex items-center gap-4 p-4 bg-white border-2 border-soil-pale rounded-lg cursor-pointer transition-all duration-200"
              :class="{
                'border-sapling bg-seed': selectedOption === index,
                'border-flourish bg-green-50': showResult && index === currentQuestion.correct_option_index,
                'border-red-400 bg-red-50': showResult && selectedOption === index && selectedOption !== currentQuestion.correct_option_index
              }"
              @click="selectOption(index)"
            >
              <div
                class="w-9 h-9 rounded-full font-mono font-bold text-sm flex items-center justify-center"
                :class="selectedOption === index || (showResult && index === currentQuestion.correct_option_index)
                  ? 'bg-sapling text-white'
                  : 'bg-soil-pale'"
              >
                {{ String.fromCharCode(65 + index) }}
              </div>
              <span>{{ option }}</span>
            </div>
          </div>

          <!-- Explanation -->
          <div v-if="showResult &&; currentQuestion.explanation"
               class="mt-6 p-4 bg-seed rounded-lg border-l-4 border-sapling"
          >
            <div class="font-semibold text-flourish mb-1">Explanation:</div>
            <p class="text-soil-medium">{{ currentQuestion.explanation }}</p>
          </div>
        </div>

        <!-- Actions -->
        <div class="flex justify-between">
          <Button variant="secondary" @click="exitQuiz">
            Exit Quiz
          </Button>

          <Button
            v-if="!showResult"
            :disabled="selectedOption === null"
            @click="submitAnswer"
          >
            Submit Answer
          </Button>

          <Button
            v-else
            @click="nextQuestion"
          >
            Next Question →
          </Button>
        </div>
      </div>

      <!-- Quiz Complete -->
      <div v-else-if="quizComplete" class="card text-center py-12">
        <div class="text-6xl mb-4">🌻</div>
        <h2 class="font-display text-2xl font-bold mb-2">Quiz Complete!</h2>
        <p class="text-soil-medium mb-6">
          You got {{ correctAnswers }} out of {{ totalQuestions }} correct
        </p>

        <div class="text-4xl font-bold text-flourish mb-8">
          {{ scorePercentage }}%
        </div>

        <div class="flex justify-center gap-4">
          <Button @click="restartQuiz">
            Try Again
          </Button>
          <Button variant="secondary" @click="$router.push('/grades')">
            Back to Garden
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
import type { QuizQuestion, QuizAttempt } from '@/types';

const api = useApi();
const route = useRoute();
const router = useRouter();

const topicId = ref(Number(route.params.topicId));
const questions = ref<QuizQuestion[]>([]);
const currentQuestionIndex = ref(0);
const selectedOption = ref<number | null>(null);
const showResult = ref(false);
const correctAnswers = ref(0);
const totalQuestions = ref(10);
const currentDifficulty = ref(1);
const loading = ref(true);
const quizComplete = ref(false);
const attempt = ref<QuizAttempt | null>(null);

const questionNumber = computed(() => currentQuestionIndex.value + 1);
const currentQuestion = computed(() => questions.value[currentQuestionIndex.value] || null);
const scorePercentage = computed(() => {
  if (totalQuestions.value === 0) return 0;
  return Math.round((correctAnswers.value / totalQuestions.value) * 100);
});

onMounted(async () => {
  await loadQuestions();
  await createAttempt();
});

async function loadQuestions() {
  try {
    const response = await api.getQuestions(topicId.value, currentDifficulty.value);
    questions.value = response.data;
  } catch (error) {
    console.error('Failed to load questions:', error);
  } finally {
    loading.value = false;
  }
}

async function createAttempt() {
  try {
    const response = await api.createAttempt(topicId.value);
    attempt.value = response.data;
  } catch (error) {
    console.error('Failed to create attempt:', error);
  }
}

function selectOption(index: number) {
  if (!showResult.value) {
    selectedOption.value = index;
  }
}

async function submitAnswer() {
  if (selectedOption.value === null || !currentQuestion.value || !attempt.value) return;

  const isCorrect = selectedOption.value === currentQuestion.value.correct_option_index;

  if (isCorrect) {
    correctAnswers.value++;
    currentDifficulty.value = Math.min(3, currentDifficulty.value + 1);
  } else {
    currentDifficulty.value = Math.max(1, currentDifficulty.value - 1);
  }

  // Submit to backend
  try {
    await api.submitAnswer({
      attempt_id: attempt.value.id,
      question_id: currentQuestion.value.id,
      selected_option_index: selectedOption.value,
      time_taken_seconds: 30, // Placeholder
    });
  } catch (error) {
    console.error('Failed to submit answer:', error);
  }

  showResult.value = true;
}

function nextQuestion() {
  currentQuestionIndex.value++;
  selectedOption.value = null;
  showResult.value = false;

  if (currentQuestionIndex.value >= totalQuestions.value) {
    quizComplete.value = true;
  }
}

function exitQuiz() {
  router.back();
}

function restartQuiz() {
  currentQuestionIndex.value = 0;
  selectedOption.value = null;
  showResult.value = false;
  correctAnswers.value = 0;
  currentDifficulty.value = 1;
  quizComplete.value = false;
  loadQuestions();
  createAttempt();
}
</script>
