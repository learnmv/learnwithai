"""Grade schemas."""
from pydantic import BaseModel, ConfigDict
from typing import Optional, List
from datetime import datetime


class GradeBase(BaseModel):
    name: str
    level: int
    description: Optional[str] = None


class GradeCreate(GradeBase):
    pass


class GradeResponse(GradeBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    created_at: datetime


class GradeWithCounts(GradeResponse):
    """Grade with subject and topic counts."""
    subject_count: int = 0
    topic_count: int = 0
