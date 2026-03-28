"""AI assistant schemas."""
from pydantic import BaseModel, ConfigDict
from typing import Optional, List
from datetime import datetime
from uuid import UUID


# Chat Message Schemas
class ChatMessageBase(BaseModel):
    message_content: str


class ChatMessageCreate(ChatMessageBase):
    topic_id: Optional[int] = None
    session_id: Optional[UUID] = None


class ChatMessageResponse(ChatMessageBase):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    user_id: UUID
    topic_id: Optional[int]
    session_id: UUID
    message_role: str
    created_at: datetime


# WebSocket Chat Schemas
class WebSocketMessage(BaseModel):
    type: str  # 'user_message', 'ai_chunk', 'ai_complete', 'error'
    content: Optional[str] = None
    session_id: Optional[UUID] = None
    full_message: Optional[str] = None


class AIChatRequest(BaseModel):
    message: str
    topic_id: Optional[int] = None
    session_id: Optional[UUID] = None
    context: Optional[dict] = None


class AIChatResponse(BaseModel):
    message: str
    session_id: UUID
    tokens_used: Optional[int] = None


# AI Quiz Generation
class AIQuizGenerateRequest(BaseModel):
    topic_id: int
    standard_code: Optional[str] = None
    difficulty: int = 1
    previous_question_ids: List[UUID] = []


class AIQuizGenerateResponse(BaseModel):
    question_text: str
    options: List[str]
    correct_option_index: int
    explanation: str
    standard_alignment: List[str] = []


# Weak Area Analysis
class WeakAreaAnalysisRequest(BaseModel):
    standard_ids: List[int]
    recent_attempts: int = 10


class WeakAreaAnalysisResponse(BaseModel):
    strong_areas: List[dict]
    weak_areas: List[dict]
    recommendations: str
