# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LearnWithAI is a California Common Core State Standards (CA CCSS) aligned learning platform with a "Digital Garden" theme. It features an AI tutor named "Sprout" using local Ollama LLM.

**Tech Stack:**
- **Backend:** FastAPI + SQLAlchemy 2.0 (async) + PostgreSQL
- **Frontend:** Vue 3 + TypeScript + Vite + Tailwind CSS + Pinia
- **AI:** Ollama (local LLM)
- **Deployment:** Kubernetes (backend only)

## External Services (Running on Host)

PostgreSQL and Ollama run on the host (10.0.0.131), not in Kubernetes:

| Service | Host:Port | K8s Connection String |
|---------|-----------|----------------------|
| PostgreSQL | 10.0.0.131:30432 | `postgresql+asyncpg://admin:admin@123@10.0.0.131:30432/learnwithai` |
| Ollama | 10.0.0.131:30434 | `http://10.0.0.131:30434` |

## Development Commands

### Backend (FastAPI)

```bash
cd /home/sysadmin/learnwithai/backend

# Install dependencies
pip install -r requirements.txt

# Run development server (uvicorn)
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Run with Docker
docker build -t learnwithai-backend:latest .
docker run -p 8000:8000 learnwithai-backend:latest
```

**API Documentation:**
- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`
- Health: `http://localhost:8000/health`

### Frontend (Vue 3)

```bash
cd /home/sysadmin/learnwithai/frontend

# Install dependencies
npm install

# Run development server
npm run dev

# Build for production
npm run build

# Type check
npm run build
```

**Development URL:** `http://localhost:5173`

## Kubernetes Deployment

Only the backend is deployed to Kubernetes (PostgreSQL and Ollama remain on host).

```bash
cd /home/sysadmin/learnwithai/k8s

# Build image first
docker build -t learnwithai-backend:latest ../backend

# Deploy development (1 replica)
kubectl apply -f dev.yml

# Deploy production (3 replicas + HPA)
kubectl apply -f prod.yml

# Check status
kubectl get pods -n learnwithai-dev
kubectl get pods -n learnwithai-prod

# View logs
kubectl logs -f deployment/backend -n learnwithai-dev

# Port forward for local access
kubectl port-forward svc/backend 8000:8000 -n learnwithai-dev

# Rolling restart (after code changes)
kubectl rollout restart deployment/backend -n learnwithai-dev
```

**Access via NodePort:**
- API: `http://10.0.0.131:30080`
- Health: `curl http://10.0.0.131:30080/health`

## Architecture Overview

### Backend Structure (`/backend/app/`)

```
app/
├── main.py                 # FastAPI app entry, CORS, router registration
├── config.py               # Pydantic settings (DATABASE_URL, OLLAMA_BASE_URL)
├── database.py             # Async SQLAlchemy engine + session factory
├── api/
│   ├── v1/                 # REST API routes
│   │   ├── auth.py         # JWT login/register
│   │   ├── grades.py       # Grade CRUD
│   │   ├── subjects.py     # Subject CRUD
│   │   ├── topics.py       # Topic CRUD + progress tracking
│   │   └── quiz.py         # Quiz generation + scoring
│   └── websocket/ai_chat.py # WebSocket for real-time AI chat
├── models/                 # SQLAlchemy ORM models
│   ├── grades.py
│   ├── domains.py          # CA CCSS domains/clusters/standards
│   ├── subjects.py
│   ├── users.py            # User + Progress + StandardMastery
│   ├── quiz.py
│   └── chat_history.py
├── schemas/                # Pydantic request/response models
├── services/
│   └── ai_service.py       # Ollama integration (chat, quiz generation)
├── repositories/
│   └── user_repo.py        # Data access layer pattern
└── core/
    ├── security.py         # JWT + password hashing
    └── exceptions.py
```

**Key Patterns:**
- **Repository Pattern:** Data access in `repositories/` (e.g., `UserRepository`)
- **Service Layer:** Business logic in `services/` (e.g., `AIService`)
- **Dependency Injection:** FastAPI `Depends()` for DB sessions and auth
- **Async SQLAlchemy:** All DB operations use `async/await` with `asyncpg`

### Frontend Structure (`/frontend/src/`)

```
src/
├── main.ts                 # Vue app entry + Pinia + Router
├── App.vue                 # Root with page transitions
├── router/
│   └── index.ts            # Route guards (auth required)
├── stores/
│   └── user.ts             # Pinia auth store (JWT)
├── composables/
│   └── useApi.ts           # Axios wrapper with auth headers
├── types/
│   └── index.ts            # TypeScript interfaces
├── components/
│   ├── common/             # AppHeader, Button, FloatingLeaves
│   └── ai/
│       └── AIAssistant.vue # Chat UI
└── views/
    ├── LoginView.vue
    ├── GradesView.vue      # Grade selection
    ├── SubjectsView.vue    # Subject cards
    ├── TopicsView.vue      # Learning tree + AI sidebar
    ├── StudyView.vue       # Topic content + practice tools
    └── QuizView.vue        # Adaptive quiz
```

**Key Patterns:**
- **Composition API:** All components use `<script setup>`
- **Pinia:** State management for auth and user data
- **API Composable:** `useApi()` provides authenticated Axios instance
- **Digital Garden Theme:** Tailwind config with custom colors (soil, sprout, bloom)

### Database Schema

**CA CCSS Aligned Tables:**
- `grades` → `domains` (RP, NS, EE, G, SP) → `clusters` → `standards` (6.RP.1)
- `subjects` → `topics` → `topic_standards` (many-to-many)

**User Tables:**
- `users` → `user_progress` (growth_stage: seed/sprout/sapling/bloom)
- `standard_mastery` (not_started → mastered)

**Quiz Tables:**
- `quiz_questions` (linked to standards)
- `quiz_attempts` → `quiz_responses`

**AI Tables:**
- `chat_history` (WebSocket session storage)

## AI Integration

**Ollama Configuration:**
- Base URL: `http://10.0.0.131:30434`
- Default Model: `llama3.2`
- Quiz Model: `mistral`

**AI Service (`services/ai_service.py`):**
- `chat()` - Streams responses via WebSocket (Socratic method)
- `generate_quiz_question()` - Creates adaptive questions
- `analyze_learning()` - Identifies weak/strong areas

**WebSocket Endpoint:** `/ws/ai-chat`
- Real-time streaming from Ollama
- Session-based chat history
- Context includes topic name and previous messages

## Important Notes

- **No CI/CD tests currently** - GitHub Actions workflows directory is empty
- **ImagePullPolicy:** `Never` in dev (local image), `Always` in prod (for registry)
- **Database Migrations:** Use `database_schema.sql` directly; Alembic configured but not actively used
- **CORS:** Configured in `config.py` via `CORS_ORIGINS` env var
