"""User and progress models."""
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Boolean, func, Text, JSON
from sqlalchemy.dialects.postgresql import UUID, ARRAY
from sqlalchemy.orm import relationship
import uuid

from app.database import Base


class User(Base):
    """Student user model."""
    __tablename__ = "users"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    email = Column(String(255), unique=True, nullable=False, index=True)
    hashed_password = Column(String(255), nullable=False)
    full_name = Column(String(255))
    avatar_url = Column(String(500))
    current_grade_id = Column(Integer, ForeignKey("grades.id"))
    is_active = Column(Boolean, default=True)
    is_superuser = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    # Relationships
    current_grade = relationship("Grade")
    user_progress = relationship("UserProgress", back_populates="user", cascade="all, delete-orphan")
    standard_mastery = relationship("StandardMastery", back_populates="user", cascade="all, delete-orphan")
    quiz_attempts = relationship("QuizAttempt", back_populates="user", cascade="all, delete-orphan")
    chat_history = relationship("ChatHistory", back_populates="user", cascade="all, delete-orphan")
    user_stats = relationship("UserStats", back_populates="user", uselist=False, cascade="all, delete-orphan")

    def __repr__(self):
        return f"<User {self.email}>"


class UserProgress(Base):
    """User learning progress per topic."""
    __tablename__ = "user_progress"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    topic_id = Column(Integer, ForeignKey("topics.id", ondelete="CASCADE"), nullable=False)
    growth_stage = Column(String(20), default="seed")  # seed, sprout, sapling, bloom
    completion_percentage = Column(Integer, default=0)
    is_completed = Column(Boolean, default=False)
    time_spent_minutes = Column(Integer, default=0)
    last_accessed = Column(DateTime(timezone=True))
    completed_at = Column(DateTime(timezone=True))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    # Relationships
    user = relationship("User", back_populates="user_progress")
    topic = relationship("Topic", back_populates="user_progress")

    def __repr__(self):
        return f"<UserProgress {self.user_id} - {self.topic_id}: {self.growth_stage}>"


class StandardMastery(Base):
    """User mastery of individual standards."""
    __tablename__ = "standard_mastery"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    standard_id = Column(Integer, ForeignKey("standards.id", ondelete="CASCADE"), nullable=False)
    mastery_level = Column(String(20), default="not_started")  # not_started, emerging, developing, proficient, mastered
    first_attempt_at = Column(DateTime(timezone=True))
    mastered_at = Column(DateTime(timezone=True))
    attempts_count = Column(Integer, default=0)
    correct_count = Column(Integer, default=0)
    last_assessed_at = Column(DateTime(timezone=True))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    # Relationships
    user = relationship("User", back_populates="standard_mastery")
    standard = relationship("Standard", back_populates="standard_mastery")

    def __repr__(self):
        return f"<StandardMastery {self.user_id} - {self.standard_id}: {self.mastery_level}>"


class UserStats(Base):
    """Denormalized user statistics for dashboard."""
    __tablename__ = "user_stats"

    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    total_topics_completed = Column(Integer, default=0)
    total_quiz_attempts = Column(Integer, default=0)
    average_score = Column(Integer, default=0)
    current_streak_days = Column(Integer, default=0)
    longest_streak_days = Column(Integer, default=0)
    strong_areas = Column(JSON, default=list)  # Array of standard IDs
    weak_areas = Column(JSON, default=list)    # Array of standard IDs
    last_activity_at = Column(DateTime(timezone=True))
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    # Relationships
    user = relationship("User", back_populates="user_stats")

    def __repr__(self):
        return f"<UserStats {self.user_id}>"
