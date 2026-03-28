"""Topic API endpoints."""
from typing import List
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.database import get_async_session
from app.models.subjects import Topic
from app.models.users import UserProgress
from app.models.domains import Standard
from app.schemas.subjects import TopicResponse, TopicWithContent
from app.core.security import get_current_user

router = APIRouter(prefix="/topics", tags=["topics"])


@router.get("/subject/{subject_id}", response_model=List[TopicResponse])
async def get_topics_by_subject(
    subject_id: int,
    db: AsyncSession = Depends(get_async_session),
    current_user = Depends(get_current_user)
):
    """Get topics for a subject with user progress."""
    result = await db.execute(
        select(Topic)
        .where(Topic.subject_id == subject_id)
        .where(Topic.is_active == True)
        .order_by(Topic.order_index)
    )
    topics = result.scalars().all()

    # Get user progress for each topic
    topic_responses = []
    for topic in topics:
        progress_result = await db.execute(
            select(UserProgress)
            .where(UserProgress.user_id == current_user.id)
            .where(UserProgress.topic_id == topic.id)
        )
        progress = progress_result.scalar_one_or_none()

        response = TopicResponse(
            **topic.__dict__,
            growth_stage=progress.growth_stage if progress else "seed",
            completion_percentage=progress.completion_percentage if progress else 0
        )
        topic_responses.append(response)

    return topic_responses


@router.get("/{topic_id}", response_model=TopicWithContent)
async def get_topic(
    topic_id: int,
    db: AsyncSession = Depends(get_async_session)
):
    """Get topic with full content."""
    result = await db.execute(
        select(Topic).where(Topic.id == topic_id)
    )
    topic = result.scalar_one_or_none()

    if not topic:
        raise HTTPException(status_code=404, detail="Topic not found")

    return TopicWithContent(**topic.__dict__)


@router.post("/{topic_id}/progress")
async def update_progress(
    topic_id: int,
    growth_stage: str,
    completion_percentage: int,
    db: AsyncSession = Depends(get_async_session),
    current_user = Depends(get_current_user)
):
    """Update user progress for a topic."""
    from datetime import datetime

    result = await db.execute(
        select(UserProgress)
        .where(UserProgress.user_id == current_user.id)
        .where(UserProgress.topic_id == topic_id)
    )
    progress = result.scalar_one_or_none()

    if not progress:
        # Create new progress
        progress = UserProgress(
            user_id=current_user.id,
            topic_id=topic_id,
            growth_stage=growth_stage,
            completion_percentage=completion_percentage,
            last_accessed=datetime.utcnow()
        )
        db.add(progress)
    else:
        progress.growth_stage = growth_stage
        progress.completion_percentage = completion_percentage
        progress.last_accessed = datetime.utcnow()

    await db.commit()
    await db.refresh(progress)

    return {"status": "success", "growth_stage": growth_stage}
