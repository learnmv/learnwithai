"""Subject API endpoints."""
from typing import List

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.database import get_async_session
from app.models.subjects import Subject
from app.models.topics import Topic
from app.schemas.subjects import SubjectResponse, SubjectWithTopics

router = APIRouter(prefix="/subjects", tags=["subjects"])


@router.get("/grade/{grade_id}", response_model=List[SubjectResponse])
async def get_subjects_by_grade(
    grade_id: int,
    db: AsyncSession = Depends(get_async_session)
):
    """Get subjects for a grade."""
    result = await db.execute(
        select(Subject)
        .where(Subject.grade_id == grade_id)
        .where(Subject.is_active == True)
        .order_by(Subject.order_index)
    )
    subjects = result.scalars().all()

    # Add progress calculation (placeholder)
    subject_responses = []
    for subject in subjects:
        # Calculate progress percentage
        topics_result = await db.execute(
            select(Topic)
            .where(Topic.subject_id == subject.id)
            .where(Topic.is_active == True)
        )
        topics = topics_result.scalars().all()

        response = SubjectResponse(
            **subject.__dict__,
            progress_percentage=0  # Will be calculated based on user progress
        )
        subject_responses.append(response)

    return subject_responses


@router.get("/{subject_id}", response_model=SubjectWithTopics)
async def get_subject(
    subject_id: int,
    db: AsyncSession = Depends(get_async_session)
):
    """Get subject with topics."""
    result = await db.execute(
        select(Subject).where(Subject.id == subject_id)
    )
    subject = result.scalar_one_or_none()

    if not subject:
        raise HTTPException(status_code=404, detail="Subject not found")

    # Get topics
    topics_result = await db.execute(
        select(Topic)
        .where(Topic.subject_id == subject_id)
        .where(Topic.is_active == True)
        .order_by(Topic.order_index)
    )
    topics = topics_result.scalars().all()

    return SubjectWithTopics(
        **subject.__dict__,
        topics=topics
    )
