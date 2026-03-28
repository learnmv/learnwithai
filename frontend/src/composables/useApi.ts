import axios from 'axios';

const api = axios.create({
  baseURL: '/api/v1',
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add auth token to requests
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Handle token expiration
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export { api };

export function useApi() {
  return {
    // Auth
    login: (email: string, password: string) =>
      api.post('/auth/login', { username: email, password }),
    register: (data: { email: string; password: string; full_name?: string }) =>
      api.post('/auth/register', data),
    getMe: () => api.get('/auth/me'),

    // Grades
    getGrades: () => api.get('/grades/'),
    getGrade: (id: number) => api.get(`/grades/${id}`),

    // Subjects
    getSubjectsByGrade: (gradeId: number) =>
      api.get(`/subjects/grade/${gradeId}`),
    getSubject: (id: number) => api.get(`/subjects/${id}`),

    // Topics
    getTopicsBySubject: (subjectId: number) =>
      api.get(`/topics/subject/${subjectId}`),
    getTopic: (id: number) => api.get(`/topics/${id}`),
    updateProgress: (topicId: number, data: { growth_stage: string; completion_percentage: number }) =>
      api.post(`/topics/${topicId}/progress`, data),

    // Quiz
    getQuestions: (topicId: number, difficulty: number) =>
      api.get(`/quiz/topics/${topicId}/questions`, { params: { difficulty } }),
    createAttempt: (topicId: number) =>
      api.post('/quiz/attempts', { topic_id: topicId }),
    submitAnswer: (data: {
      attempt_id: string;
      question_id: string;
      selected_option_index: number;
      time_taken_seconds?: number;
    }) => api.post('/quiz/answer', data),
  };
}
