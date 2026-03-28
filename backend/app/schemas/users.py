"""User and authentication schemas."""
from pydantic import BaseModel, ConfigDict, EmailStr
from typing import Optional, List
from datetime import datetime
from uuid import UUID


# User Schemas
class UserBase(BaseModel):
    email: EmailStr
    full_name: Optional[str] = None


class UserCreate(UserBase):
    password: str
    current_grade_id: Optional[int] = None


class UserLogin(BaseModel):
    email: EmailStr
    password: str


class UserResponse(UserBase):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    avatar_url: Optional[str] = None
    current_grade_id: Optional[int] = None
    is_active: bool
    created_at: datetime


class UserProfile(UserResponse):
    """Full user profile with stats."""
    total_topics_completed: int = 0
    current_streak_days: int = 0
    strong_areas: List[int] = []
    weak_areas: List[int] = []


# Progress Schemas
class UserProgressBase(BaseModel):
    topic_id: int
    growth_stage: str = "seed"
    completion_percentage: int = 0


class UserProgressUpdate(BaseModel):
    growth_stage: Optional[str] = None
    completion_percentage: Optional[int] = None
    time_spent_minutes: Optional[int] = None


class UserProgressResponse(UserProgressBase):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    user_id: UUID
    is_completed: bool
    last_accessed: Optional[datetime]
    completed_at: Optional[datetime]


# Standard Mastery Schemas
class StandardMasteryBase(BaseModel):
    standard_id: int
    mastery_level: str = "not_started"


class StandardMasteryUpdate(BaseModel):
    mastery_level: Optional[str] = None
    attempts_count: Optional[int] = None
    correct_count: Optional[int] = None


class StandardMasteryResponse(StandardMasteryBase):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    user_id: UUID
    first_attempt_at: Optional[datetime]
    mastered_at: Optional[datetime]


# User Stats Schemas
class UserStatsResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    total_topics_completed: int = 0
    total_quiz_attempts: int = 0
    average_score: int = 0
    current_streak_days: int = 0
    longest_streak_days: int = 0
    strong_areas: List[int] = []
    weak_areas: List[int] = []
    last_activity_at: Optional[datetime]


# Token Schemas
class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"


class TokenData(BaseModel):
    user_id: Optional[str] = None
