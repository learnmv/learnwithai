<template>
  <div class="min-h-screen flex items-center justify-center py-12 px-4">
    <div class="max-w-md w-full">
      <!-- Logo -->
      <div class="text-center mb-8">
        <div class="w-16 h-16 rounded-full flex items-center justify-center text-3xl mx-auto mb-4"
             style="background: linear-gradient(135deg, #66BB6A 0%, #43A047 100%);">
          🌱
        </div>
        <h1 class="font-display text-3xl font-bold text-soil-dark">Welcome Back</h1>
        <p class="text-soil-medium mt-2">Sign in to continue your learning journey</p>
      </div>

      <!-- Form -->
      <div class="card">
        <form @submit.prevent="handleLogin" class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-soil-dark mb-1">Email</label>
            <input
              v-model="email"
              type="email"
              required
              class="w-full px-4 py-3 rounded-lg border-2 border-soil-pale focus:border-sapling focus:outline-none transition-colors"
              placeholder="you@example.com"
            />
          </div>

          <div>
            <label class="block text-sm font-medium text-soil-dark mb-1">Password</label>
            <input
              v-model="password"
              type="password"
              required
              class="w-full px-4 py-3 rounded-lg border-2 border-soil-pale focus:border-sapling focus:outline-none transition-colors"
              placeholder="••••••••"
            />
          </div>

          <div v-if="error" class="p-3 bg-red-50 border border-red-200 rounded-lg text-red-600 text-sm">
            {{ error }}
          </div>

          <Button type="submit" :loading="loading" class="w-full">
            Sign In
          </Button>
        </form>

        <div class="mt-6 text-center">
          <p class="text-sm text-soil-medium">
            Don't have an account?
            <router-link to="/register" class="text-flourish font-semibold hover:underline">
              Sign up
            </router-link>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useUserStore } from '@/stores/user';
import Button from '@/components/common/Button.vue';

const router = useRouter();
const route = useRoute();
const userStore = useUserStore();

const email = ref('');
const password = ref('');
const loading = ref(false);
const error = ref('');

async function handleLogin() {
  loading.value = true;
  error.value = '';

  const success = await userStore.login(email.value, password.value);

  if (success) {
    const redirect = route.query.redirect as string;
    router.push(redirect || '/grades');
  } else {
    error.value = userStore.error || 'Login failed';
  }

  loading.value = false;
}
</script>
