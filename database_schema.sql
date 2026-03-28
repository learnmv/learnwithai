-- LearnWithAI Database Schema
-- California Common Core State Standards (CA CCSS) Aligned
-- Run with: psql -h localhost -p 5432 -U admin -d learnwithai -f database_schema.sql

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- CORE TABLES - CA CCSS Structure
-- ============================================

-- Grades table (6-12 initially, scalable)
CREATE TABLE grades (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,           -- e.g., "Grade 6"
    level INTEGER NOT NULL UNIQUE,        -- 6, 7, 8, etc.
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Domains - CA CCSS domains per grade (RP, NS, EE, G, SP)
CREATE TABLE domains (
    id SERIAL PRIMARY KEY,
    grade_id INTEGER REFERENCES grades(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,             -- "Ratios and Proportional Relationships"
    code VARCHAR(20) NOT NULL,              -- "RP", "NS", "EE", "G", "SP"
    description TEXT,
    order_index INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Clusters - Groups of related standards
CREATE TABLE clusters (
    id SERIAL PRIMARY KEY,
    domain_id INTEGER REFERENCES domains(id) ON DELETE CASCADE,
    name VARCHAR(300) NOT NULL,
    description TEXT,
    order_index INTEGER DEFAULT 0
);

-- Standards - Individual CA CCSS standards
CREATE TABLE standards (
    id SERIAL PRIMARY KEY,
    cluster_id INTEGER REFERENCES clusters(id) ON DELETE CASCADE,
    standard_code VARCHAR(50) UNIQUE NOT NULL,  -- "6.RP.1", "6.NS.3"
    description TEXT NOT NULL,
    learning_objective TEXT,                -- Student-facing: "I can..."
    is_major_work BOOLEAN DEFAULT FALSE,     -- Critical areas
    is_california_addition BOOLEAN DEFAULT FALSE,
    order_index INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Subjects - Academic subjects
CREATE TABLE subjects (
    id SERIAL PRIMARY KEY,
    grade_id INTEGER REFERENCES grades(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,              -- "Mathematics"
    slug VARCHAR(100) UNIQUE NOT NULL,         -- "mathematics"
    description TEXT,
    icon VARCHAR(50),                        -- Emoji or icon name
    color_theme VARCHAR(50),                 -- "math", "science", etc.
    order_index INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Topics - Learning units
CREATE TABLE topics (
    id SERIAL PRIMARY KEY,
    subject_id INTEGER REFERENCES subjects(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    slug VARCHAR(200) UNIQUE NOT NULL,
    description TEXT,
    content JSONB,                          -- Flexible lesson content
    difficulty_level INTEGER DEFAULT 1,      -- 1-5 scale
    estimated_minutes INTEGER,               -- Time to complete
    prerequisites INTEGER[],                 -- Array of topic IDs
    order_index INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Topic-Standards link (many-to-many)
CREATE TABLE topic_standards (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    topic_id INTEGER REFERENCES topics(id) ON DELETE CASCADE,
    standard_id INTEGER REFERENCES standards(id) ON DELETE CASCADE,
    coverage_level VARCHAR(20) DEFAULT 'develop',  -- 'introduce', 'develop', 'master'
    priority INTEGER DEFAULT 1,                      -- 1=primary, 2=secondary
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(topic_id, standard_id)
);

-- ============================================
-- USER TABLES
-- ============================================

-- Users - Student accounts
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255),
    avatar_url VARCHAR(500),
    current_grade_id INTEGER REFERENCES grades(id),
    is_active BOOLEAN DEFAULT TRUE,
    is_superuser BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User Progress - Learning progress per topic
CREATE TABLE user_progress (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    topic_id INTEGER REFERENCES topics(id) ON DELETE CASCADE,
    growth_stage VARCHAR(20) DEFAULT 'seed',  -- 'seed', 'sprout', 'sapling', 'bloom'
    completion_percentage INTEGER DEFAULT 0,   -- 0-100
    is_completed BOOLEAN DEFAULT FALSE,
    time_spent_minutes INTEGER DEFAULT 0,
    last_accessed TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, topic_id)
);

-- Standard Mastery - Standards-based progress
CREATE TABLE standard_mastery (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    standard_id INTEGER REFERENCES standards(id) ON DELETE CASCADE,
    mastery_level VARCHAR(20) DEFAULT 'not_started',  -- 'not_started', 'emerging', 'developing', 'proficient', 'mastered'
    first_attempt_at TIMESTAMP WITH TIME ZONE,
    mastered_at TIMESTAMP WITH TIME ZONE,
    attempts_count INTEGER DEFAULT 0,
    correct_count INTEGER DEFAULT 0,
    last_assessed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, standard_id)
);

-- User Stats - Denormalized dashboard data
CREATE TABLE user_stats (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    total_topics_completed INTEGER DEFAULT 0,
    total_quiz_attempts INTEGER DEFAULT 0,
    average_score INTEGER DEFAULT 0,
    current_streak_days INTEGER DEFAULT 0,
    longest_streak_days INTEGER DEFAULT 0,
    strong_areas INTEGER[] DEFAULT '{}',      -- Array of standard IDs
    weak_areas INTEGER[] DEFAULT '{}',        -- Array of standard IDs
    last_activity_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- QUIZ SYSTEM TABLES
-- ============================================

-- Quiz Questions - Question bank (infinite quiz)
CREATE TABLE quiz_questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    topic_id INTEGER REFERENCES topics(id) ON DELETE CASCADE,
    standard_id INTEGER REFERENCES standards(id) ON DELETE SET NULL,
    question_text TEXT NOT NULL,
    options JSONB NOT NULL,                    -- Array of answer options
    correct_option_index INTEGER NOT NULL,
    difficulty_level INTEGER DEFAULT 1,         -- 1-3 scale
    explanation TEXT,
    question_type VARCHAR(50) DEFAULT 'multiple_choice',
    tags TEXT[],                                -- For adaptive quiz
    times_used INTEGER DEFAULT 0,
    times_correct INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Quiz Attempts - Quiz sessions
CREATE TABLE quiz_attempts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    topic_id INTEGER REFERENCES topics(id) ON DELETE CASCADE,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE,
    total_questions INTEGER DEFAULT 0,
    correct_answers INTEGER DEFAULT 0,
    score_percentage INTEGER,
    difficulty_reached INTEGER DEFAULT 1,
    streak_count INTEGER DEFAULT 0,
    metadata JSONB,                             -- Adaptive tracking data
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Quiz Responses - Individual answers
CREATE TABLE quiz_responses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    attempt_id UUID REFERENCES quiz_attempts(id) ON DELETE CASCADE,
    question_id UUID REFERENCES quiz_questions(id) ON DELETE CASCADE,
    selected_option_index INTEGER,
    is_correct BOOLEAN,
    time_taken_seconds INTEGER,
    answered_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- AI ASSISTANT TABLES
-- ============================================

-- Chat History - AI conversation logs
CREATE TABLE chat_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    topic_id INTEGER REFERENCES topics(id) ON DELETE SET NULL,
    session_id UUID DEFAULT uuid_generate_v4(),
    message_role VARCHAR(20) NOT NULL,         -- 'user' or 'assistant'
    message_content TEXT NOT NULL,
    context JSONB,                              -- Topic context, previous messages
    tokens_used INTEGER,
    model_used VARCHAR(100),                     -- e.g., 'llama3.2'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

-- User indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_grade ON users(current_grade_id);

-- Standards indexes
CREATE INDEX idx_standards_code ON standards(standard_code);
CREATE INDEX idx_standards_cluster ON standards(cluster_id);
CREATE INDEX idx_standards_major ON standards(is_major_work);

-- Progress indexes
CREATE INDEX idx_user_progress_user ON user_progress(user_id);
CREATE INDEX idx_user_progress_topic ON user_progress(topic_id);
CREATE INDEX idx_user_progress_stage ON user_progress(growth_stage);

-- Mastery indexes
CREATE INDEX idx_standard_mastery_user ON standard_mastery(user_id);
CREATE INDEX idx_standard_mastery_standard ON standard_mastery(standard_id);
CREATE INDEX idx_standard_mastery_level ON standard_mastery(mastery_level);

-- Quiz indexes
CREATE INDEX idx_quiz_questions_topic ON quiz_questions(topic_id);
CREATE INDEX idx_quiz_questions_standard ON quiz_questions(standard_id);
CREATE INDEX idx_quiz_questions_difficulty ON quiz_questions(difficulty_level);
CREATE INDEX idx_quiz_attempts_user ON quiz_attempts(user_id);
CREATE INDEX idx_quiz_attempts_topic ON quiz_attempts(topic_id);

-- Topic-Standards indexes
CREATE INDEX idx_topic_standards_topic ON topic_standards(topic_id);
CREATE INDEX idx_topic_standards_standard ON topic_standards(standard_id);

-- Chat indexes
CREATE INDEX idx_chat_history_user ON chat_history(user_id);
CREATE INDEX idx_chat_history_session ON chat_history(session_id);
CREATE INDEX idx_chat_history_topic ON chat_history(topic_id);

-- Full-text search for topics
CREATE INDEX idx_topics_search ON topics USING gin(to_tsvector('english', name || ' ' || COALESCE(description, '')));

-- ============================================
-- SEED DATA - CA CCSS 6th Grade Domains
-- ============================================

-- Insert grades 6-8 (initial)
INSERT INTO grades (name, level, description) VALUES
    ('Grade 6', 6, 'California Common Core 6th Grade Mathematics'),
    ('Grade 7', 7, 'California Common Core 7th Grade Mathematics'),
    ('Grade 8', 8, 'California Common Core 8th Grade Mathematics');

-- Insert 6th Grade Domains
INSERT INTO domains (grade_id, name, code, description, order_index) VALUES
    (1, 'Ratios and Proportional Relationships', 'RP', 'Understand ratio concepts and use ratio reasoning to solve problems', 1),
    (1, 'The Number System', 'NS', 'Apply and extend previous understandings of multiplication and division to divide fractions by fractions', 2),
    (1, 'Expressions and Equations', 'EE', 'Apply and extend previous understandings of arithmetic to algebraic expressions', 3),
    (1, 'Geometry', 'G', 'Solve real-world and mathematical problems involving area, surface area, and volume', 4),
    (1, 'Statistics and Probability', 'SP', 'Develop understanding of statistical variability', 5);

-- Insert 6th Grade Clusters for RP Domain
INSERT INTO clusters (domain_id, name, description, order_index) VALUES
    (1, 'Understand ratio concepts and use ratio reasoning to solve problems', 'Major Work Cluster', 1);

-- Insert Sample Standards for RP Domain
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (1, '6.RP.1', 'Understand the concept of a ratio and use ratio language to describe a ratio relationship between two quantities.', 'I can use ratio language to describe relationships between quantities', TRUE, 1),
    (1, '6.RP.2', 'Understand the concept of a unit rate a/b associated with a ratio a:b with b ≠ 0, and use rate language in the context of a ratio relationship.', 'I can understand unit rates and use rate language', TRUE, 2),
    (1, '6.RP.3', 'Use ratio and rate reasoning to solve real-world and mathematical problems.', 'I can use ratios and rates to solve problems', TRUE, 3);

-- Insert Math Subject for Grade 6
INSERT INTO subjects (grade_id, name, slug, description, icon, color_theme, order_index) VALUES
    (1, 'Mathematics', 'mathematics', 'California Common Core State Standards for Mathematics', '📐', 'math', 1);

-- Insert Sample Topics
INSERT INTO topics (subject_id, name, slug, description, difficulty_level, estimated_minutes, order_index) VALUES
    (1, 'Introduction to Ratios', 'intro-to-ratios', 'Learn what ratios are and how to describe relationships between quantities', 1, 45, 1),
    (1, 'Unit Rates', 'unit-rates', 'Understand unit rates and solve rate problems', 2, 60, 2),
    (1, 'Equivalent Ratios', 'equivalent-ratios', 'Work with equivalent ratios and ratio tables', 2, 60, 3);

-- Link Topics to Standards
INSERT INTO topic_standards (topic_id, standard_id, coverage_level, priority) VALUES
    (1, 1, 'introduce', 1),   -- Intro to Ratios covers 6.RP.1
    (2, 2, 'master', 1),      -- Unit Rates covers 6.RP.2
    (3, 3, 'develop', 1);     -- Equivalent Ratios covers 6.RP.3

-- ============================================
-- TABLE SUMMARY
-- ============================================
-- Total tables created: 15
-- Core Tables: 7 (grades, domains, clusters, standards, subjects, topics, topic_standards)
-- User Tables: 4 (users, user_progress, standard_mastery, user_stats)
-- Quiz Tables: 3 (quiz_questions, quiz_attempts, quiz_responses)
-- AI Tables: 1 (chat_history)
-- ============================================

SELECT 'Database schema created successfully!' AS status;
SELECT 'Tables created: 15' AS summary;
