import { createRouter, createWebHistory } from 'vue-router';
import { useUserStore } from '@/stores/user';

const routes = [
  {
    path: '/',
    name: 'home',
    redirect: '/grades',
  },
  {
    path: '/login',
    name: 'login',
    component: () => import('@/views/LoginView.vue'),
    meta: { public: true },
  },
  {
    path: '/register',
    name: 'register',
    component: () => import('@/views/RegisterView.vue'),
    meta: { public: true },
  },
  {
    path: '/grades',
    name: 'grades',
    component: () => import('@/views/GradesView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/subjects/:gradeId',
    name: 'subjects',
    component: () => import('@/views/SubjectsView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/topics/:subjectId',
    name: 'topics',
    component: () => import('@/views/TopicsView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/study/:topicId',
    name: 'study',
    component: () => import('@/views/StudyView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/quiz/:topicId',
    name: 'quiz',
    component: () => import('@/views/QuizView.vue'),
    meta: { requiresAuth: true },
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 };
  },
});

// Navigation guards
router.beforeEach(async (to, from, next) => {
  const userStore = useUserStore();

  // Check if route requires auth
  if (to.meta.requiresAuth && !userStore.isAuthenticated) {
    // Try to restore session
    await userStore.fetchUser();

    if (!userStore.isAuthenticated) {
      next({ name: 'login', query: { redirect: to.fullPath } });
      return;
    }
  }

  // Redirect authenticated users away from auth pages
  if (to.meta.public && userStore.isAuthenticated) {
    next({ name: 'grades' });
    return;
  }

  next();
});

export default router;
