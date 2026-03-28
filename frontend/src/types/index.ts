// Grade types
export interface Grade {
  id: number;
  name: string;
  level: number;
  description?: string;
}

// Subject types
export interface Subject {
  id: number;
  grade_id: number;
  name: string;
  slug: string;
  description?: string;
  icon?: string;
  color_theme?: string;
  progress_percentage: number;
}

// Topic types
export interface Topic {
  id: number;
  subject_id: number;
  name: string;
  slug: string;
  description?: string;
  content?: TopicContent;
  difficulty_level: number;
  estimated_minutes?: number;
  growth_stage: 'seed' | 'sprout' | 'sapling' | 'bloom';
  completion_percentage: number;
  order_index: number;
}

export interface TopicContent {
  sections: ContentSection[];
  examples: Example[];
  practice_tools: PracticeTool[];
}

export interface ContentSection {
  title: string;
  content: string;
}

export interface Example {
  label: string;
  content: string;
}

export interface PracticeTool {
  name: string;
  type: string;
  config: Record<string, unknown>;
}

// User types
export interface User {
  id: string;
  email: string;
  full_name?: string;
  avatar_url?: string;
  current_grade_id?: number;
}

// Quiz types
export interface QuizQuestion {
  id: string;
  topic_id: number;
  question_text: string;
  options: string[];
  difficulty_level: number;
  explanation?: string;
}

export interface QuizAttempt {
  id: string;
  topic_id: number;
  total_questions: number;
  correct_answers: number;
  score_percentage?: number;
  difficulty_reached: number;
  streak_count: number;
}

// AI Chat types
export interface ChatMessage {
  id: string;
  message_role: 'user' | 'assistant';
  message_content: string;
  created_at: string;
}

export interface UserStats {
  total_topics_completed: number;
  total_quiz_attempts: number;
  average_score: number;
  current_streak_days: number;
  longest_streak_days: number;
  strong_areas: number[];
  weak_areas: number[];
}

// Standard types (CA CCSS)
export interface Standard {
  id: number;
  standard_code: string;
  description: string;
  learning_objective?: string;
  is_major_work: boolean;
}
