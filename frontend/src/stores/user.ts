import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import type { User, UserStats } from '@/types';
import { useApi } from '@/composables/useApi';

const api = useApi();

export const useUserStore = defineStore('user', () => {
  // State
  const user = ref<User | null>(null);
  const token = ref<string | null>(localStorage.getItem('token'));
  const stats = ref<UserStats | null>(null);
  const isLoading = ref(false);
  const error = ref<string | null>(null);

  // Getters
  const isAuthenticated = computed(() => !!token.value && !!user.value);
  const currentGrade = computed(() => user.value?.current_grade_id);

  // Actions
  async function login(email: string, password: string) {
    isLoading.value = true;
    error.value = null;

    try {
      const formData = new FormData();
      formData.append('username', email);
      formData.append('password', password);

      const response = await api.login(email, password);
      token.value = response.data.access_token;
      localStorage.setItem('token', response.data.access_token);

      await fetchUser();
      return true;
    } catch (err: any) {
      error.value = err.response?.data?.detail || 'Login failed';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  async function register(email: string, password: string, fullName?: string) {
    isLoading.value = true;
    error.value = null;

    try {
      await api.register({ email, password, full_name: fullName });
      return await login(email, password);
    } catch (err: any) {
      error.value = err.response?.data?.detail || 'Registration failed';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  async function fetchUser() {
    if (!token.value) return;

    try {
      const response = await api.getMe();
      user.value = response.data;
    } catch (err) {
      logout();
    }
  }

  function logout() {
    user.value = null;
    token.value = null;
    stats.value = null;
    localStorage.removeItem('token');
  }

  return {
    user,
    token,
    stats,
    isLoading,
    error,
    isAuthenticated,
    currentGrade,
    login,
    register,
    fetchUser,
    logout,
  };
});
