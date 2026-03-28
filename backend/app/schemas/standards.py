"""CA CCSS Standards schemas."""
from pydantic import BaseModel, ConfigDict
from typing import Optional, List
from datetime import datetime


class StandardBase(BaseModel):
    standard_code: str
    description: str
    learning_objective: Optional[str] = None
    is_major_work: bool = False


class StandardResponse(StandardBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    cluster_id: int
    created_at: datetime


class StandardWithMastery(StandardResponse):
    """Standard with user mastery info."""
    mastery_level: str = "not_started"
    attempts_count: int = 0


class DomainBase(BaseModel):
    name: str
    code: str
    description: Optional[str] = None


class DomainResponse(DomainBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    grade_id: int
    standards: List[StandardResponse] = []


class ClusterBase(BaseModel):
    name: str
    description: Optional[str] = None


class ClusterResponse(ClusterBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    domain_id: int
    standards: List[StandardResponse] = []
