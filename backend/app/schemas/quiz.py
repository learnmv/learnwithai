"""Quiz system schemas."""
from pydantic import BaseModel, ConfigDict
from typing import Optional, List
from datetime import datetime
from uuid import UUID


# Quiz Question Schemas
class QuizQuestionBase(BaseModel):
    question_text: str
    options: List[str]
    difficulty_level: int = 1


class QuizQuestionCreate(QuizQuestionBase):
    topic_id: int
    standard_id: Optional[int] = None
    correct_option_index: int
    explanation: Optional[str] = None


class QuizQuestionResponse(QuizQuestionBase):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    topic_id: int
    standard_id: Optional[int]
    question_type: str
    created_at: datetime


class QuizQuestionWithAnswer(QuizQuestionResponse):
    """Full question with correct answer (for after submission)."""
    correct_option_index: int
    explanation: Optional[str] = None


# Quiz Attempt Schemas
class QuizAttemptCreate(BaseModel):
    topic_id: int


class QuizAttemptResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    user_id: UUID
    topic_id: int
    started_at: datetime
    completed_at: Optional[datetime]
    total_questions: int
    correct_answers: int
    score_percentage: Optional[int]
    difficulty_reached: int
    streak_count: int


# Quiz Response Schemas
class QuizAnswerSubmit(BaseModel):
    attempt_id: UUID
    question_id: UUID
    selected_option_index: int
    time_taken_seconds: Optional[int] = None


class QuizAnswerResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    is_correct: bool
    correct_option_index: int
    explanation: Optional[str] = None
    next_question: Optional[QuizQuestionResponse] = None
    attempt_complete: bool = False
    score_percentage: Optional[int] = None


# Adaptive Quiz Request
class AdaptiveQuizRequest(BaseModel):
    topic_id: int
    difficulty: Optional[int] = 1
    exclude_question_ids: List[UUID] = []
