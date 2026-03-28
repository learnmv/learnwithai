<template>
  <div class="min-h-screen">
    <!-- Floating Leaves Background -->
    <FloatingLeaves />

    <!-- Header -->
    <AppHeader v-if="!isAuthPage" />

    <!-- Main Content -->
    <main :class="{ 'pt-20': !isAuthPage }">
      <router-view v-slot="{ Component }">
        <transition name="grow" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
    </main>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useRoute } from 'vue-router';
import AppHeader from '@/components/common/AppHeader.vue';
import FloatingLeaves from '@/components/common/FloatingLeaves.vue';

const route = useRoute();
const isAuthPage = computed(() => {
  return ['login', 'register'].includes(route.name as string);
});
</script>

<style>
/* Page transition animation - Grow In */
.grow-enter-active,
.grow-leave-active {
  transition: all 0.5s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.grow-enter-from {
  opacity: 0;
  transform: translateY(20px) scale(0.98);
}

.grow-leave-to {
  opacity: 0;
  transform: translateY(-20px) scale(0.98);
}

/* Scrollbar styling */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: #FAF7F2;
}

::-webkit-scrollbar-thumb {
  background: #D4C4B0;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #8B7355;
}
</style>