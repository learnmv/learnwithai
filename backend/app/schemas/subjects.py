"""Subject and Topic schemas."""
from pydantic import BaseModel, ConfigDict
from typing import Optional, List
from datetime import datetime


# Topic Schemas
class TopicBase(BaseModel):
    name: str
    description: Optional[str] = None
    difficulty_level: int = 1
    estimated_minutes: Optional[int] = None


class TopicCreate(TopicBase):
    subject_id: int
    content: Optional[dict] = None
    prerequisites: List[int] = []


class TopicResponse(TopicBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    subject_id: int
    slug: str
    growth_stage: str = "seed"
    completion_percentage: int = 0
    order_index: int
    is_active: bool
    created_at: datetime


class TopicWithContent(TopicResponse):
    """Topic with full content for study mode."""
    content: Optional[dict] = None
    prerequisites: List[int] = []


# Subject Schemas
class SubjectBase(BaseModel):
    name: str
    description: Optional[str] = None
    icon: Optional[str] = None
    color_theme: Optional[str] = None


class SubjectCreate(SubjectBase):
    grade_id: int


class SubjectResponse(SubjectBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    grade_id: int
    slug: str
    order_index: int
    is_active: bool
    created_at: datetime
    progress_percentage: int = 0


class SubjectWithTopics(SubjectResponse):
    """Subject with all topics."""
    topics: List[TopicResponse] = []
