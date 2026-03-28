# LearnWithAI Technical Architecture Plan

## Overview
Complete technical blueprint for building LearnWithAI with FastAPI backend, Vue 3 frontend, PostgreSQL database, and Ollama local AI.

---

## Tech Stack Summary

| Layer | Technology | Purpose |
|-------|------------|---------|
| **Frontend** | Vue 3 + TypeScript + Vite | User interface with Digital Garden theme |
| **Styling** | Tailwind CSS + Custom CSS | Organic animations, color system |
| **State** | Pinia | User progress, quiz state, AI chat |
| **Backend** | FastAPI + Python 3.11+ | High-performance async API |
| **Database** | PostgreSQL 15+ | Relational data with JSON support |
| **ORM** | SQLAlchemy 2.0 + asyncpg | Async database operations |
| **Migrations** | Alembic | Schema versioning |
| **AI** | Ollama (Local) | Private LLM inference (Llama 3, Mistral) |
| **WebSocket** | FastAPI native | Real-time AI chat |
| **Container** | Docker + Docker Compose | Development & deployment |

---

## Project Structure

```
learnwithai/
├── docker-compose.yml              # Full stack orchestration
├── .env.example                    # Environment template
│
├── backend/                        # FastAPI Application
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── alembic.ini                 # Migration config
│   ├── pyproject.toml              # Poetry dependencies
│   │
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py                 # FastAPI app entry
│   │   ├── config.py               # Pydantic settings
│   │   ├── database.py             # Async engine & session
│   │   │
│   │   ├── api/                    # API Routes
│   │   │   ├── __init__.py
│   │   │   ├── deps.py             # Dependencies (get_db, get_current_user)
│   │   │   ├── v1/
│   │   │   │   ├── __init__.py
│   │   │   │   ├── grades.py       # Grade endpoints
│   │   │   │   ├── subjects.py     # Subject endpoints
│   │   │   │   ├── topics.py       # Topic endpoints
│   │   │   │   ├── quiz.py         # Quiz endpoints
│   │   │   │   ├── users.py        # User auth & profile
│   │   │   │   └── ai.py           # AI chat endpoints
│   │   │   └── websocket/
│   │   │       └── ai_chat.py      # WebSocket for real-time AI
│   │   │
│   │   ├── models/                 # SQLAlchemy ORM Models
│   │   │   ├── __init__.py
│   │   │   ├── base.py             # Base class
│   │   │   ├── user.py             # User model
│   │   │   ├── grade.py            # Grade model
│   │   │   ├── subject.py          # Subject model
│   │   │   ├── topic.py            # Topic model
│   │   │   ├── user_progress.py    # Learning progress
│   │   │   ├── quiz.py             # Quiz & questions
│   │   │   └── chat_history.py     # AI conversation history
│   │   │
│   │   ├── schemas/                # Pydantic Schemas
│   │   │   ├── __init__.py
│   │   │   ├── user.py
│   │   │   ├── grade.py
│   │   │   ├── subject.py
│   │   │   ├── topic.py
│   │   │   ├── quiz.py
│   │   │   └── ai.py
│   │   │
│   │   ├── services/               # Business Logic
│   │   │   ├── __init__.py
│   │   │   ├── user_service.py
│   │   │   ├── quiz_service.py     # Quiz generation & scoring
│   │   │   ├── progress_service.py # Progress tracking
│   │   │   └── ai_service.py       # Ollama integration
│   │   │
│   │   ├── repositories/           # Data Access Layer
│   │   │   ├── __init__.py
│   │   │   ├── user_repo.py
│   │   │   ├── grade_repo.py
│   │   │   ├── subject_repo.py
│   │   │   ├── topic_repo.py
│   │   │   └── quiz_repo.py
│   │   │
│   │   └── core/                   # Security & Utils
│   │       ├── __init__.py
│   │       ├── security.py         # JWT, password hashing
│   │       ├── logging.py          # Structured logging
│   │       └── exceptions.py       # Custom exceptions
│   │
│   └── alembic/                    # Database Migrations
│       ├── env.py
│       ├── script.py.mako
│       └── versions/               # Migration files
│
├── frontend/                       # Vue 3 Application
│   ├── Dockerfile
│   ├── package.json
│   ├── tsconfig.json
│   ├── vite.config.ts
│   ├── tailwind.config.js
│   │
│   ├── src/
│   │   ├── main.ts                 # Vue app entry
│   │   ├── App.vue                 # Root component
│   │   ├── router/                 # Vue Router
│   │   │   └── index.ts
│   │   │
│   │   ├── components/             # Vue Components
│   │   │   ├── common/
│   │   │   │   ├── Button.vue
│   │   │   │   ├── Card.vue
│   │   │   │   └── ProgressBar.vue
│   │   │   ├── grades/
│   │   │   │   └── GradeCard.vue
│   │   │   ├── subjects/
│   │   │   │   └── SubjectCard.vue
│   │   │   ├── topics/
│   │   │   │   ├── TopicNode.vue
│   │   │   │   └── GrowthStage.vue
│   │   │   ├── quiz/
│   │   │   │   ├── QuizCard.vue
│   │   │   │   └── AnswerOption.vue
│   │   │   └── ai/
│   │   │       ├── AIAssistant.vue
│   │   │       └── ChatMessage.vue
│   │   │
│   │   ├── views/                  # Page Views
│   │   │   ├── GradesView.vue
│   │   │   ├── SubjectsView.vue
│   │   │   ├── TopicsView.vue
│   │   │   ├── StudyView.vue
│   │   │   └── QuizView.vue
│   │   │
│   │   ├── stores/                 # Pinia Stores
│   │   │   ├── user.ts
│   │   │   ├── grades.ts
│   │   │   ├── subjects.ts
│   │   │   ├── topics.ts
│   │   │   ├── quiz.ts
│   │   │   └── ai.ts
│   │   │
│   │   ├── composables/            # Vue 3 Composables
│   │   │   ├── useApi.ts           # Axios/Fetch wrapper
│   │   │   ├── useAuth.ts          # Authentication
│   │   │   ├── useWebSocket.ts     # AI chat WebSocket
│   │   │   └── useAnimations.ts    # GSAP animations
│   │   │
│   │   ├── types/                  # TypeScript Interfaces
│   │   │   └── index.ts            # Shared with Pydantic
│   │   │
│   │   ├── styles/                 # Styling
│   │   │   ├── main.css            # Tailwind imports
│   │   │   ├── variables.css       # CSS custom properties
│   │   │   └── animations.css      # Garden animations
│   │   │
│   │   └── utils/                  # Utilities
│   │       ├── constants.ts
│   │       └── helpers.ts
│   │
│   └── public/                     # Static assets
│
└── database/                       # Database Setup
    ├── init.sql                    # Initial schema (optional)
    └── seed_data/                  # Seed data for development
        ├── grades.json
        ├── subjects.json
        └── topics.json
```

---

## Database Schema (PostgreSQL)

### Entity Relationship Diagram

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   grades    │────▶│  subjects    │────▶│   topics    │
├─────────────┤     ├──────────────┤     ├─────────────┤
│ id (PK)     │     │ id (PK)      │     │ id (PK)     │
│ name        │     │ grade_id(FK) │     │ subject_id  │
│ level       │     │ name         ││(FK)│ name        │
│ order       │     │ description  │     │ description │
│ created_at  │     │ icon         │     │ order       │
└─────────────┘     │ color_theme  │     │ lessons_count│
                    │ created_at   │     │ created_at  │
                    └──────────────┘     └─────────────┘
                                                  │
                                                  ▼
                                           ┌─────────────┐
                                           │user_progress│
                                           ├─────────────┤
                                           │ id (PK)     │
                                           │ user_id(FK) │
                                           │ topic_id(FK)│
                                           │ stage       │
                                           │ completed   │
                                           │ updated_at  │
                                           └─────────────┘
```

### Complete Schema

```sql
-- Users Table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255),
    avatar_url VARCHAR(500),
    current_grade_id INTEGER,
    is_active BOOLEAN DEFAULT TRUE,
    is_superuser BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Grades Table (Scalable - supports K-12, College, etc.)
CREATE TABLE grades (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,           -- e.g., "6th Grade", "Freshman"
    level INTEGER NOT NULL UNIQUE,        -- Numeric level for ordering
    description TEXT,
    min_age INTEGER,
    max_age INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Subjects Table
CREATE TABLE subjects (
    id SERIAL PRIMARY KEY,
    grade_id INTEGER REFERENCES grades(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,           -- e.g., "Mathematics"
    slug VARCHAR(100) UNIQUE NOT NULL,    -- URL-friendly: "mathematics"
    description TEXT,
    icon VARCHAR(50),                     -- Emoji or icon name
    color_theme VARCHAR(50),              -- "math", "science", etc.
    order_index INTEGER DEFAULT 0,        -- Display order
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Topics Table (Learning units)
CREATE TABLE topics (
    id SERIAL PRIMARY KEY,
    subject_id INTEGER REFERENCES subjects(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    slug VARCHAR(200) UNIQUE NOT NULL,
    description TEXT,
    content JSONB,                        -- Flexible content structure
    difficulty_level INTEGER DEFAULT 1, -- 1-5 scale
    estimated_minutes INTEGER,            -- Time to complete
    prerequisites INTEGER[],              -- Array of topic IDs
    order_index INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User Progress Tracking
CREATE TABLE user_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    topic_id INTEGER REFERENCES topics(id) ON DELETE CASCADE,
    -- Growth stages: seed, sprout, sapling, bloom
    growth_stage VARCHAR(20) DEFAULT 'seed',
    completion_percentage INTEGER DEFAULT 0,
    is_completed BOOLEAN DEFAULT FALSE,
    time_spent_minutes INTEGER DEFAULT 0,
    last_accessed TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, topic_id)
);

-- Quiz Questions (Infinite quiz system)
CREATE TABLE quiz_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    topic_id INTEGER REFERENCES topics(id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    options JSONB NOT NULL,               -- Array of options
    correct_option_index INTEGER NOT NULL,
    difficulty_level INTEGER DEFAULT 1,
    explanation TEXT,
    question_type VARCHAR(50) DEFAULT 'multiple_choice',
    tags TEXT[],                          -- For adaptive quiz
    times_used INTEGER DEFAULT 0,
    times_correct INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Quiz Attempts
CREATE TABLE quiz_attempts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    topic_id INTEGER REFERENCES topics(id) ON DELETE CASCADE,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE,
    total_questions INTEGER DEFAULT 0,
    correct_answers INTEGER DEFAULT 0,
    score_percentage INTEGER,
    difficulty_reached INTEGER DEFAULT 1,
    streak_count INTEGER DEFAULT 0,
    metadata JSONB                        -- Adaptive tracking data
);

-- Quiz Responses
CREATE TABLE quiz_responses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    attempt_id UUID REFERENCES quiz_attempts(id) ON DELETE CASCADE,
    question_id UUID REFERENCES quiz_questions(id) ON DELETE CASCADE,
    selected_option_index INTEGER,
    is_correct BOOLEAN,
    time_taken_seconds INTEGER,
    answered_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- AI Chat History
CREATE TABLE chat_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    topic_id INTEGER REFERENCES topics(id) ON DELETE SET NULL,
    session_id UUID DEFAULT gen_random_uuid(),
    message_role VARCHAR(20) NOT NULL,    -- 'user' or 'assistant'
    message_content TEXT NOT NULL,
    context JSONB,                        -- Topic context, previous messages
    tokens_used INTEGER,
    model_used VARCHAR(100),              -- e.g., 'llama3:8b'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User Stats (Denormalized for quick dashboard)
CREATE TABLE user_stats (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    total_topics_completed INTEGER DEFAULT 0,
    total_quiz_attempts INTEGER DEFAULT 0,
    average_score INTEGER DEFAULT 0,
    current_streak_days INTEGER DEFAULT 0,
    longest_streak_days INTEGER DEFAULT 0,
    strong_areas JSONB DEFAULT '[]',     -- Array of subject IDs
    weak_areas JSONB DEFAULT '[]',       -- Array of subject IDs
    last_activity_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for Performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_subjects_grade ON subjects(grade_id);
CREATE INDEX idx_topics_subject ON topics(subject_id);
CREATE INDEX idx_user_progress_user ON user_progress(user_id);
CREATE INDEX idx_user_progress_topic ON user_progress(topic_id);
CREATE INDEX idx_user_progress_stage ON user_progress(growth_stage);
CREATE INDEX idx_quiz_questions_topic ON quiz_questions(topic_id);
CREATE INDEX idx_quiz_attempts_user ON quiz_attempts(user_id);
CREATE INDEX idx_chat_history_user ON chat_history(user_id);
CREATE INDEX idx_chat_history_session ON chat_history(session_id);

-- Full-text search for topics
CREATE INDEX idx_topics_search ON topics USING gin(to_tsvector('english', name || ' ' || coalesce(description, '')));
```

---

## Ollama Integration Architecture

### Architecture Flow

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   Vue 3     │────▶│   FastAPI    │────▶│   Ollama    │
│   Frontend  │◄────│   Backend    │◄────│  (Local)    │
└─────────────┘     └──────────────┘     └─────────────┘
                           │
                           ▼
                    ┌──────────────┐
                    │  PostgreSQL  │
                    │  Chat History│
                    └──────────────┘
```

### Ollama Service Configuration

```yaml
# docker-compose.yml snippet
services:
  ollama:
    image: ollama/ollama:latest
    container_name: learnwithai-ollama
    volumes:
      - ollama_data:/root/.ollama
    ports:
      - "11434:11434"
    environment:
      - OLLAMA_KEEP_ALIVE=24h
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
    # Pre-download models on startup
    entrypoint: |
      sh -c '
        /bin/ollama serve &
        sleep 5
        ollama pull llama3.2
        ollama pull mistral
        ollama pull gemma:2b
        wait
      '
```

### FastAPI AI Service Implementation

```python
# app/services/ai_service.py
import json
from typing import AsyncGenerator, List, Optional
import httpx
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.chat_history import ChatHistory
from app.schemas.ai import AIChatRequest, AIChatResponse


class AIService:
    """Service for Ollama LLM interactions"""

    def __init__(self, base_url: str = "http://ollama:11434"):
        self.base_url = base_url
        self.client = httpx.AsyncClient(timeout=60.0)

    async def chat(
        self,
        message: str,
        context: Optional[dict] = None,
        model: str = "llama3.2",
        system_prompt: Optional[str] = None
    ) -> AsyncGenerator[str, None]:
        """
        Stream AI response for educational guidance.
        Uses Socratic method - guides without giving direct answers.
        """

        # Build system prompt for educational context
        if not system_prompt:
            system_prompt = self._build_educational_prompt(context)

        # Build conversation history
        messages = [
            {"role": "system", "content": system_prompt},
        ]

        # Add context from previous messages if available
        if context and "chat_history" in context:
            for chat in context["chat_history"]:
                messages.append({
                    "role": chat["role"],
                    "content": chat["content"]
                })

        messages.append({"role": "user", "content": message})

        # Call Ollama API
        response = await self.client.post(
            f"{self.base_url}/api/chat",
            json={
                "model": model,
                "messages": messages,
                "stream": True,
                "options": {
                    "temperature": 0.7,
                    "top_p": 0.9,
                    "num_ctx": 4096
                }
            }
        )

        # Stream response chunks
        async for line in response.aiter_lines():
            if line:
                try:
                    data = json.loads(line)
                    if "message" in data and "content" in data["message"]:
                        yield data["message"]["content"]
                except json.JSONDecodeError:
                    continue

    def _build_educational_prompt(self, context: Optional[dict]) -> str:
        """Build system prompt for Socratic learning"""

        topic = context.get("topic_name", "this topic") if context else "this topic"

        return f"""You are Sprout, an AI learning companion for students.

CURRENT TOPIC: {topic}

GUIDELINES:
- Never give direct answers to homework questions
- Use the Socratic method: ask guiding questions
- Encourage critical thinking and exploration
- Break complex concepts into manageable steps
- Celebrate progress and effort
- If student is stuck, provide hints, not solutions

RESPONSE STYLE:
- Warm, encouraging, patient
- Use analogies and real-world examples
- Keep responses concise (2-4 sentences)
- End with a thought-provoking question when appropriate

Remember: Your goal is to help students discover answers themselves!"""

    async def generate_quiz_question(
        self,
        topic: str,
        difficulty: int,
        previous_questions: List[str]
    ) -> dict:
        """Generate adaptive quiz questions"""

        prompt = f"""Generate a {['easy', 'medium', 'hard'][difficulty-1]} math question about {topic}.

Requirements:
- 4 multiple choice options
- Only ONE correct answer
- Clear, unambiguous wording
- Real-world context if possible

Return ONLY valid JSON in this format:
{{
    "question": "question text",
    "options": ["option A", "option B", "option C", "option D"],
    "correct_index": 0,
    "explanation": "why this is correct"
}}

Previous questions to avoid: {previous_questions}"""

        response = await self.client.post(
            f"{self.base_url}/api/generate",
            json={
                "model": "mistral",
                "prompt": prompt,
                "format": "json",
                "options": {"temperature": 0.8}
            }
        )

        result = response.json()
        return json.loads(result["response"])

    async def analyze_weak_areas(
        self,
        user_responses: List[dict]
    ) -> dict:
        """Analyze quiz responses to identify weak areas"""

        prompt = f"""Analyze these quiz responses and identify:
1. Strongest topic area
2. Weakest topic area (needs more practice)
3. Recommended next steps

Responses: {json.dumps(user_responses)}

Return JSON:
{{
    "strong_areas": ["topic1", "topic2"],
    "weak_areas": ["topic3"],
    "recommendations": "personalized advice"
}}"""

        response = await self.client.post(
            f"{self.base_url}/api/generate",
            json={
                "model": "llama3.2",
                "prompt": prompt,
                "format": "json"
            }
        )

        return json.loads(response.json()["response"])

    async def close(self):
        await self.client.aclose()
```

### WebSocket for Real-time Chat

```python
# app/api/websocket/ai_chat.py
from fastapi import APIRouter, WebSocket, WebSocketDisconnect, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_async_session
from app.services.ai_service import AIService
from app.repositories.chat_repo import ChatRepository

router = APIRouter()


@router.websocket("/ws/ai-chat")
async def ai_chat_websocket(
    websocket: WebSocket,
    db: AsyncSession = Depends(get_async_session)
):
    """WebSocket endpoint for real-time AI chat"""

    await websocket.accept()
    ai_service = AIService()
    chat_repo = ChatRepository(db)

    try:
        while True:
            # Receive message from client
            data = await websocket.receive_json()
            user_message = data.get("message")
            topic_id = data.get("topic_id")
            session_id = data.get("session_id")

            # Get chat history for context
            chat_history = await chat_repo.get_recent_messages(
                user_id=data.get("user_id"),
                session_id=session_id,
                limit=5
            )

            # Stream AI response
            full_response = ""
            async for chunk in ai_service.chat(
                message=user_message,
                context={
                    "topic_name": data.get("topic_name"),
                    "chat_history": chat_history
                }
            ):
                full_response += chunk
                await websocket.send_json({
                    "type": "chunk",
                    "content": chunk
                })

            # Send completion signal
            await websocket.send_json({
                "type": "complete",
                "full_message": full_response
            })

            # Save to database
            await chat_repo.save_message(
                user_id=data.get("user_id"),
                topic_id=topic_id,
                session_id=session_id,
                role="user",
                content=user_message
            )
            await chat_repo.save_message(
                user_id=data.get("user_id"),
                topic_id=topic_id,
                session_id=session_id,
                role="assistant",
                content=full_response
            )

    except WebSocketDisconnect:
        await ai_service.close()
    except Exception as e:
        await websocket.send_json({"type": "error", "message": str(e)})
        await ai_service.close()
```

---

## Key Implementation Details

### 1. Async Database Pattern

```python
# app/database.py
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker, declarative_base

DATABASE_URL = "postgresql+asyncpg://user:pass@db:5432/learnwithai"

engine = create_async_engine(
    DATABASE_URL,
    pool_size=5,
    max_overflow=10,
    pool_timeout=30,
    pool_recycle=1800,
    pool_pre_ping=True,
    echo=False
)

AsyncSessionLocal = sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False
)

Base = declarative_base()

async def get_async_session():
    async with AsyncSessionLocal() as session:
        try:
            yield session
        except Exception:
            await session.rollback()
            raise
        finally:
            await session.close()
```

### 2. Repository Pattern Example

```python
# app/repositories/topic_repo.py
from sqlalchemy import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.topic import Topic
from app.schemas.topic import TopicCreate, TopicUpdate


class TopicRepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def get_by_subject(self, subject_id: int) -> list[Topic]:
        result = await self.db.execute(
            select(Topic)
            .where(Topic.subject_id == subject_id)
            .where(Topic.is_active == True)
            .order_by(Topic.order_index)
        )
        return result.scalars().all()

    async def get_with_progress(self, topic_id: int, user_id: str):
        from app.models.user_progress import UserProgress

        result = await self.db.execute(
            select(Topic, UserProgress)
            .outerjoin(
                UserProgress,
                (UserProgress.topic_id == Topic.id) &
                (UserProgress.user_id == user_id)
            )
            .where(Topic.id == topic_id)
        )
        return result.first()

    async def create(self, topic: TopicCreate) -> Topic:
        db_topic = Topic(**topic.dict())
        self.db.add(db_topic)
        await self.db.commit()
        await self.db.refresh(db_topic)
        return db_topic
```

### 3. Pydantic + TypeScript Sharing

```python
# app/schemas/topic.py
from pydantic import BaseModel
from typing import Optional, List

class TopicBase(BaseModel):
    name: str
    description: Optional[str] = None
    order_index: int = 0

class TopicCreate(TopicBase):
    subject_id: int

class TopicResponse(TopicBase):
    id: int
    subject_id: int
    lessons_count: int
    growth_stage: str = "seed"  # From user_progress

    class Config:
        from_attributes = True

# Generate TypeScript interfaces
# Run: pydantic2ts --module app.schemas.topic --output ../frontend/src/types/topic.ts
```

---

## Scaling Considerations

### Horizontal Scaling

```yaml
# docker-compose.prod.yml
services:
  app:
    build: ./backend
    deploy:
      replicas: 3
    environment:
      - DATABASE_URL=postgresql+asyncpg://user:pass@pgbouncer:5432/learnwithai

  pgbouncer:
    image: pgbouncer/pgbouncer:latest
    environment:
      - DATABASES_HOST=postgres
      - DATABASES_PORT=5432
      - DATABASES_DATABASE=learnwithai
      - POOL_MODE=transaction
      - MAX_CLIENT_CONN=10000

  postgres:
    image: postgres:15-alpine
    volumes:
      - postgres_data:/var/lib/postgresql/data
    deploy:
      resources:
        limits:
          memory: 2G
```

### Caching Strategy

```python
# Use Redis for:
# - User sessions
# - Quiz question cache
# - Progress summaries
# - Rate limiting on AI endpoints

from redis.asyncio import Redis

redis = Redis.from_url("redis://redis:6379")

async def get_cached_progress(user_id: str):
    cached = await redis.get(f"progress:{user_id}")
    if cached:
        return json.loads(cached)
    # Fetch from DB and cache
```

---

## Development Commands

```bash
# Start all services
docker-compose up -d

# Run migrations
docker-compose exec backend alembic upgrade head

# Create migration
docker-compose exec backend alembic revision --autogenerate -m "add users table"

# Seed database
docker-compose exec backend python -m app.seed_data

# View logs
docker-compose logs -f backend
docker-compose logs -f ollama

# Install new model in Ollama
docker-compose exec ollama ollama pull llama3.2

# Frontend development
cd frontend && npm run dev

# Backend development
cd backend && uvicorn app.main:app --reload
```

---

## Environment Variables

```bash
# .env
# Database
DATABASE_URL=postgresql+asyncpg://postgres:password@db:5432/learnwithai

# Security
SECRET_KEY=your-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# Ollama
OLLAMA_BASE_URL=http://ollama:11434
DEFAULT_MODEL=llama3.2
QUIZ_MODEL=mistral

# Frontend
VITE_API_URL=http://localhost:8000
VITE_WS_URL=ws://localhost:8000
```

---

## Resources

- [FastAPI + Ollama Integration](https://medium.com/@simeon.emanuilov/ollama-with-fastapi-7f43cf532c43)
- [SQLAlchemy Async Best Practices](https://leapcell.io/blog/building-high-performance-async-apis-with-fastapi-sqlalchemy-2-0-and-asyncpg)
- [E-learning Database Design](https://www.geeksforgeeks.org/sql/how-to-design-a-database-for-online-learning-platform/)
- [Production FastAPI Structure 2026](https://dev.to/thesius_code_7a136ae718b7/production-ready-fastapi-project-structure-2026-guide-b1g)
- [Local RAG with Ollama 2026](https://medium.com/@athicharttangpong/building-a-simple-local-rag-stack-with-ollama-and-fastapi-893d192b4e06)
