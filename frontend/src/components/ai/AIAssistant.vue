<template>
  <div class="rounded-lg p-5 text-white relative overflow-hidden"
       style="background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);"
  >
    <!-- Animated background -->
    <div class="absolute -top-1/2 -left-1/2 w-full h-full opacity-10 pointer-events-none"
         style="background: radial-gradient(circle at 30% 30%, rgba(102, 187, 106, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 70% 70%, rgba(244, 143, 177, 0.3) 0%, transparent 50%);"
    />

    <!-- Header -->
    <div class="flex items-center gap-3 mb-4 relative z-10">
      <div class="w-11 h-11 rounded-full flex items-center justify-center text-xl"
           style="background: linear-gradient(135deg, #66BB6A, #43A047);"
      >
        🌿
      </div>
      <div>
        <div class="font-semibold">Sprout</div>
        <div class="flex items-center gap-1 text-xs text-white/70">
          <span class="w-2 h-2 bg-green-500 rounded-full animate-pulse"></span>
          Online
        </div>
      </div>
    </div>

    <!-- Message -->
    <div class="bg-white/10 rounded-lg p-3 text-sm mb-4 relative z-10">
      Hi there! I'm Sprout, your AI learning companion. I'm here to help you understand concepts better—think of me as a guide who asks questions and helps you discover answers yourself.
    </div>

    <!-- Input -->
    <div class="flex gap-2 relative z-10">
      <input
        v-model="message"
        type="text"
        placeholder="Ask me anything..."
        class="flex-1 bg-white/10 border border-white/20 rounded-full px-4 py-2 text-sm text-white placeholder-white/50 focus:outline-none focus:bg-white/20 focus:border-white/40"
        @keyup.enter="sendMessage"
      />
      <button
        class="w-10 h-10 rounded-full bg-sapling flex items-center justify-center hover:bg-flourish transition-colors"
        @click="sendMessage"
      >
        ➤
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

const message = ref('');

function sendMessage() {
  if (message.value.trim()) {
    // TODO: Implement WebSocket connection to backend
    console.log('Sending message:', message.value);
    message.value = '';
  }
}
</script>
