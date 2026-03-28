"""Grade API endpoints."""
from typing import List

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.database import get_async_session
from app.models.grades import Grade
from app.models.subjects import Subject, Topic
from app.schemas.grades import GradeResponse, GradeWithCounts

router = APIRouter(prefix="/grades", tags=["grades"])


@router.get("/", response_model=List[GradeResponse])
async def get_grades(
    db: AsyncSession = Depends(get_async_session)
):
    """Get all available grades."""
    result = await db.execute(select(Grade).order_by(Grade.level))
    grades = result.scalars().all()
    return grades


@router.get("/{grade_id}", response_model=GradeWithCounts)
async def get_grade(
    grade_id: int,
    db: AsyncSession = Depends(get_async_session)
):
    """Get grade with counts."""
    result = await db.execute(
        select(Grade).where(Grade.id == grade_id)
    )
    grade = result.scalar_one_or_none()

    if not grade:
        raise HTTPException(status_code=404, detail="Grade not found")

    # Get counts
    subjects_result = await db.execute(
        select(Subject).where(Subject.grade_id == grade_id)
    )
    subjects = subjects_result.scalars().all()

    topics_count = 0
    for subject in subjects:
        topics_result = await db.execute(
            select(Topic).where(Topic.subject_id == subject.id)
        )
        topics_count += len(topics_result.scalars().all())

    return GradeWithCounts(
        **grade.__dict__,
        subject_count=len(subjects),
        topic_count=topics_count
    )
