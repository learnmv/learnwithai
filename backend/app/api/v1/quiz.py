"""Quiz API endpoints."""
from typing import List
from uuid import UUID
from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func

from app.database import get_async_session
from app.models.quiz import QuizQuestion, QuizAttempt, QuizResponse
from app.models.users import User
from app.schemas.quiz import (
    QuizQuestionResponse, QuizAttemptCreate, QuizAttemptResponse,
    QuizAnswerSubmit, QuizAnswerResponse, AdaptiveQuizRequest
)
from app.core.security import get_current_user
from app.services.ai_service import AIService

router = APIRouter(prefix="/quiz", tags=["quiz"])


@router.get("/topics/{topic_id}/questions", response_model=List[QuizQuestionResponse])
async def get_questions(
    topic_id: int,
    difficulty: int = 1,
    limit: int = 10,
    db: AsyncSession = Depends(get_async_session)
):
    """Get quiz questions for a topic."""
    result = await db.execute(
        select(QuizQuestion)
        .where(QuizQuestion.topic_id == topic_id)
        .where(QuizQuestion.difficulty_level == difficulty)
        .order_by(func.random())
        .limit(limit)
    )
    questions = result.scalars().all()
    return questions


@router.post("/attempts", response_model=QuizAttemptResponse)
async def create_attempt(
    attempt_data: QuizAttemptCreate,
    db: AsyncSession = Depends(get_async_session),
    current_user: User = Depends(get_current_user)
):
    """Start a new quiz attempt."""
    attempt = QuizAttempt(
        user_id=current_user.id,
        topic_id=attempt_data.topic_id
    )
    db.add(attempt)
    await db.commit()
    await db.refresh(attempt)
    return attempt


@router.post("/answer", response_model=QuizAnswerResponse)
async def submit_answer(
    answer: QuizAnswerSubmit,
    db: AsyncSession = Depends(get_async_session),
    current_user: User = Depends(get_current_user)
):
    """Submit an answer and get next question."""
    # Get question
    result = await db.execute(
        select(QuizQuestion).where(QuizQuestion.id == answer.question_id)
    )
    question = result.scalar_one_or_none()

    if not question:
        raise HTTPException(status_code=404, detail="Question not found")

    # Check if answer is correct
    is_correct = answer.selected_option_index == question.correct_option_index

    # Create response record
    response = QuizResponse(
        attempt_id=answer.attempt_id,
        question_id=answer.question_id,
        selected_option_index=answer.selected_option_index,
        is_correct=is_correct,
        time_taken_seconds=answer.time_taken_seconds
    )
    db.add(response)

    # Update attempt stats
    attempt_result = await db.execute(
        select(QuizAttempt).where(QuizAttempt.id == answer.attempt_id)
    )
    attempt = attempt_result.scalar_one()

    attempt.total_questions += 1
    if is_correct:
        attempt.correct_answers += 1
        attempt.streak_count += 1
    else:
        attempt.streak_count = 0

    # Calculate score percentage
    attempt.score_percentage = int((attempt.correct_answers / attempt.total_questions) * 100)

    # Adjust difficulty
    if attempt.streak_count >= 3 and attempt.difficulty_reached < 3:
        attempt.difficulty_reached += 1
    elif attempt.streak_count == 0 and attempt.difficulty_reached > 1:
        attempt.difficulty_reached -= 1

    await db.commit()

    # Get next question
    next_question_result = await db.execute(
        select(QuizQuestion)
        .where(QuizQuestion.topic_id == attempt.topic_id)
        .where(QuizQuestion.difficulty_level == attempt.difficulty_reached)
        .where(QuizQuestion.id != answer.question_id)
        .order_by(func.random())
        .limit(1)
    )
    next_question = next_question_result.scalar_one_or_none()

    return QuizAnswerResponse(
        is_correct=is_correct,
        correct_option_index=question.correct_option_index,
        explanation=question.explanation,
        next_question=next_question,
        attempt_complete=attempt.total_questions >= 10,  # Limit to 10 questions
        score_percentage=attempt.score_percentage
    )


@router.get("/attempts/{attempt_id}", response_model=QuizAttemptResponse)
async def get_attempt(
    attempt_id: UUID,
    db: AsyncSession = Depends(get_async_session),
    current_user: User = Depends(get_current_user)
):
    """Get quiz attempt details."""
    result = await db.execute(
        select(QuizAttempt)
        .where(QuizAttempt.id == attempt_id)
        .where(QuizAttempt.user_id == current_user.id)
    )
    attempt = result.scalar_one_or_none()

    if not attempt:
        raise HTTPException(status_code=404, detail="Attempt not found")

    return attempt


@router.post("/adaptive/generate")
async def generate_adaptive_question(
    request: AdaptiveQuizRequest,
    ai_service: AIService = Depends(),
    db: AsyncSession = Depends(get_async_session)
):
    """Generate adaptive quiz question using AI."""
    # Get topic info
    from app.models.subjects import Topic
    topic_result = await db.execute(
        select(Topic).where(Topic.id == request.topic_id)
    )
    topic = topic_result.scalar_one_or_none()

    if not topic:
        raise HTTPException(status_code=404, detail="Topic not found")

    # Generate question using AI
    question_data = await ai_service.generate_quiz_question(
        topic=topic.name,
        standard_code=None,
        difficulty=request.difficulty,
        previous_questions=[str(qid) for qid in request.exclude_question_ids]
    )

    return question_data
