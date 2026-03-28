<template>
  <div class="min-h-screen flex items-center justify-center py-12 px-4">
    <div class="max-w-md w-full">
      <!-- Logo -->
      <div class="text-center mb-8">
        <div class="w-16 h-16 rounded-full flex items-center justify-center text-3xl mx-auto mb-4"
             style="background: linear-gradient(135deg, #66BB6A 0%, #43A047 100%);"
        >
          🌱
        </div>
        <h1 class="font-display text-3xl font-bold text-soil-dark">Create Account</h1>
        <p class="text-soil-medium mt-2">Start your learning journey today</p>
      </div>

      <!-- Form -->
      <div class="card">
        <form @submit.prevent="handleRegister" class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-soil-dark mb-1">Full Name</label>
            <input
              v-model="fullName"
              type="text"
              class="w-full px-4 py-3 rounded-lg border-2 border-soil-pale focus:border-sapling focus:outline-none transition-colors"
              placeholder="John Doe"
            />
          </div>

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
              minlength="8"
              class="w-full px-4 py-3 rounded-lg border-2 border-soil-pale focus:border-sapling focus:outline-none transition-colors"
              placeholder="••••••••"
            />
            <p class="text-xs text-soil-light mt-1">Must be at least 8 characters</p>
          </div>

          <div v-if="error" class="p-3 bg-red-50 border border-red-200 rounded-lg text-red-600 text-sm">
            {{ error }}
          </div>

          <Button type="submit" :loading="loading" class="w-full">
            Create Account
          </Button>
        </form>

        <div class="mt-6 text-center">
          <p class="text-sm text-soil-medium">
            Already have an account?
            <router-link to="/login" class="text-flourish font-semibold hover:underline">
              Sign in
            </router-link>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useUserStore } from '@/stores/user';
import Button from '@/components/common/Button.vue';

const router = useRouter();
const userStore = useUserStore();

const fullName = ref('');
const email = ref('');
const password = ref('');
const loading = ref(false);
const error = ref('');

async function handleRegister() {
  if (password.value.length < 8) {
    error.value = 'Password must be at least 8 characters';
    return;
  }

  loading.value = true;
  error.value = '';

  const success = await userStore.register(email.value, password.value, fullName.value);

  if (success) {
    router.push('/grades');
  } else {
    error.value = userStore.error || 'Registration failed';
  }

  loading.value = false;
}
</script>
