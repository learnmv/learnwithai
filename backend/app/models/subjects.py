"""Subject and Topic models."""
from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey, Boolean, func, JSON
from sqlalchemy.orm import relationship

from app.database import Base


class Subject(Base):
    """Academic subject model."""
    __tablename__ = "subjects"

    id = Column(Integer, primary_key=True, index=True)
    grade_id = Column(Integer, ForeignKey("grades.id", ondelete="CASCADE"), nullable=False)
    name = Column(String(100), nullable=False)
    slug = Column(String(100), unique=True, nullable=False)
    description = Column(Text)
    icon = Column(String(50))
    color_theme = Column(String(50))
    order_index = Column(Integer, default=0)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    grade = relationship("Grade", back_populates="subjects")
    topics = relationship("Topic", back_populates="subject", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Subject {self.name}>"


class Topic(Base):
    """Learning topic/unit model."""
    __tablename__ = "topics"

    id = Column(Integer, primary_key=True, index=True)
    subject_id = Column(Integer, ForeignKey("subjects.id", ondelete="CASCADE"), nullable=False)
    name = Column(String(200), nullable=False)
    slug = Column(String(200), unique=True, nullable=False)
    description = Column(Text)
    content = Column(JSON)  # Flexible lesson content
    difficulty_level = Column(Integer, default=1)
    estimated_minutes = Column(Integer)
    prerequisites = Column(JSON, default=list)  # Array of topic IDs
    order_index = Column(Integer, default=0)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    subject = relationship("Subject", back_populates="topics")
    topic_standards = relationship("TopicStandard", back_populates="topic")
    user_progress = relationship("UserProgress", back_populates="topic")
    quiz_questions = relationship("QuizQuestion", back_populates="topic")
    chat_history = relationship("ChatHistory", back_populates="topic")

    def __repr__(self):
        return f"<Topic {self.name}>"


class TopicStandard(Base):
    """Link between topics and standards (many-to-many)."""
    __tablename__ = "topic_standards"

    id = Column(Integer, primary_key=True)
    topic_id = Column(Integer, ForeignKey("topics.id", ondelete="CASCADE"), nullable=False)
    standard_id = Column(Integer, ForeignKey("standards.id", ondelete="CASCADE"), nullable=False)
    coverage_level = Column(String(20), default="develop")  # introduce, develop, master
    priority = Column(Integer, default=1)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    topic = relationship("Topic", back_populates="topic_standards")
    standard = relationship("Standard", back_populates="topic_standards")

    def __repr__(self):
        return f"<TopicStandard {self.topic_id} - {self.standard_id}>"
