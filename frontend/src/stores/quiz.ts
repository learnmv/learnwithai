import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import type { QuizQuestion, QuizAttempt } from '@/types';
import { useApi } from '@/composables/useApi';

const api = useApi();

export const useQuizStore = defineStore('quiz', () => {
  // State
  const currentAttempt = ref<QuizAttempt | null>(null);
  const currentQuestion = ref<QuizQuestion | null>(null);
  const questions = ref<QuizQuestion[]>([]);
  const questionIndex = ref(0);
  const score = ref(0);
  const difficulty = ref(1);
  const isLoading = ref(false);
  const selectedOption = ref<number | null>(null);
  const showResult = ref(false);
  const isCorrect = ref(false);

  // Getters
  const progress = computed(() => {
    if (!currentAttempt.value) return 0;
    return (currentAttempt.value.total_questions / 10) * 100;
  });

  const streak = computed(() => currentAttempt.value?.streak_count || 0);

  // Actions
  async function startQuiz(topicId: number) {
    isLoading.value = true;
    try {
      // Create attempt
      const attemptRes = await api.createAttempt(topicId);
      currentAttempt.value = attemptRes.data;

      // Get questions
      const questionsRes = await api.getQuestions(topicId, difficulty.value);
      questions.value = questionsRes.data;
      currentQuestion.value = questions.value[0];
      questionIndex.value = 0;
      score.value = 0;
    } finally {
      isLoading.value = false;
    }
  }

  async function submitAnswer(optionIndex: number) {
    if (!currentAttempt.value || !currentQuestion.value) return;

    selectedOption.value = optionIndex;
    isLoading.value = true;

    try {
      const response = await api.submitAnswer({
        attempt_id: currentAttempt.value.id,
        question_id: currentQuestion.value.id,
        selected_option_index: optionIndex,
        time_taken_seconds: 30, // TODO: track actual time
      });

      isCorrect.value = response.data.is_correct;
      showResult.value = true;

      // Update attempt
      if (currentAttempt.value) {
        currentAttempt.value.total_questions = response.data.total_questions || currentAttempt.value.total_questions + 1;
        if (isCorrect.value) {
          currentAttempt.value.correct_answers++;
          currentAttempt.value.streak_count++;
        } else {
          currentAttempt.value.streak_count = 0;
        }
      }

      // Move to next question or finish
      setTimeout(() => {
        if (response.data.next_question) {
          currentQuestion.value = response.data.next_question;
          selectedOption.value = null;
          showResult.value = false;
          questionIndex.value++;
        } else {
          // Quiz complete
          currentQuestion.value = null;
        }
      }, 1500);
    } finally {
      isLoading.value = false;
    }
  }

  function resetQuiz() {
    currentAttempt.value = null;
    currentQuestion.value = null;
    questions.value = [];
    questionIndex.value = 0;
    score.value = 0;
    selectedOption.value = null;
    showResult.value = false;
    isCorrect.value = false;
  }

  return {
    currentAttempt,
    currentQuestion,
    questions,
    questionIndex,
    score,
    difficulty,
    isLoading,
    selectedOption,
    showResult,
    isCorrect,
    progress,
    streak,
    startQuiz,
    submitAnswer,
    resetQuiz,
  };
});
