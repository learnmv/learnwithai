"""Quiz system models."""
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Boolean, func, JSON, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
import uuid

from app.database import Base


class QuizQuestion(Base):
    """Quiz question bank for infinite adaptive quiz."""
    __tablename__ = "quiz_questions"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    topic_id = Column(Integer, ForeignKey("topics.id", ondelete="CASCADE"), nullable=False)
    standard_id = Column(Integer, ForeignKey("standards.id", ondelete="SET NULL"))
    question_text = Column(Text, nullable=False)
    options = Column(JSON, nullable=False)  # Array of answer options
    correct_option_index = Column(Integer, nullable=False)
    difficulty_level = Column(Integer, default=1)  # 1-3 scale
    explanation = Column(Text)
    question_type = Column(String(50), default="multiple_choice")
    tags = Column(JSON, default=list)  # For adaptive quiz
    times_used = Column(Integer, default=0)
    times_correct = Column(Integer, default=0)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    topic = relationship("Topic", back_populates="quiz_questions")
    standard = relationship("Standard", back_populates="quiz_questions")
    quiz_responses = relationship("QuizResponse", back_populates="question")

    def __repr__(self):
        return f"<QuizQuestion {self.id}: {self.question_text[:50]}...>"


class QuizAttempt(Base):
    """Quiz attempt/session tracking."""
    __tablename__ = "quiz_attempts"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    topic_id = Column(Integer, ForeignKey("topics.id", ondelete="CASCADE"), nullable=False)
    started_at = Column(DateTime(timezone=True), server_default=func.now())
    completed_at = Column(DateTime(timezone=True))
    total_questions = Column(Integer, default=0)
    correct_answers = Column(Integer, default=0)
    score_percentage = Column(Integer)
    difficulty_reached = Column(Integer, default=1)
    streak_count = Column(Integer, default=0)
    attempt_adaptive_data = Column(JSON)  # Adaptive tracking data
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    user = relationship("User", back_populates="quiz_attempts")
    quiz_responses = relationship("QuizResponse", back_populates="attempt", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<QuizAttempt {self.id}: {self.correct_answers}/{self.total_questions}>"


class QuizResponse(Base):
    """Individual quiz responses."""
    __tablename__ = "quiz_responses"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    attempt_id = Column(UUID(as_uuid=True), ForeignKey("quiz_attempts.id", ondelete="CASCADE"), nullable=False)
    question_id = Column(UUID(as_uuid=True), ForeignKey("quiz_questions.id", ondelete="CASCADE"), nullable=False)
    selected_option_index = Column(Integer)
    is_correct = Column(Boolean)
    time_taken_seconds = Column(Integer)
    answered_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    attempt = relationship("QuizAttempt", back_populates="quiz_responses")
    question = relationship("QuizQuestion", back_populates="quiz_responses")

    def __repr__(self):
        return f"<QuizResponse {self.id}: {'correct' if self.is_correct else 'incorrect'}>"
