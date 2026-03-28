import { defineStore } from 'pinia';
import { ref } from 'vue';
import type { Grade, Subject, Topic } from '@/types';
import { useApi } from '@/composables/useApi';

const api = useApi();

export const useGradesStore = defineStore('grades', () => {
  // State
  const grades = ref<Grade[]>([]);
  const currentGrade = ref<Grade | null>(null);
  const subjects = ref<Subject[]>([]);
  const topics = ref<Topic[]>([]);
  const isLoading = ref(false);

  // Actions
  async function fetchGrades() {
    isLoading.value = true;
    try {
      const response = await api.getGrades();
      grades.value = response.data;
    } finally {
      isLoading.value = false;
    }
  }

  async function selectGrade(grade: Grade) {
    currentGrade.value = grade;
    await fetchSubjects(grade.id);
  }

  async function fetchSubjects(gradeId: number) {
    isLoading.value = true;
    try {
      const response = await api.getSubjectsByGrade(gradeId);
      subjects.value = response.data;
    } finally {
      isLoading.value = false;
    }
  }

  async function fetchTopics(subjectId: number) {
    isLoading.value = true;
    try {
      const response = await api.getTopicsBySubject(subjectId);
      topics.value = response.data;
    } finally {
      isLoading.value = false;
    }
  }

  function getTopicById(id: number) {
    return topics.value.find(t => t.id === id);
  }

  return {
    grades,
    currentGrade,
    subjects,
    topics,
    isLoading,
    fetchGrades,
    selectGrade,
    fetchSubjects,
    fetchTopics,
    getTopicById,
  };
});
