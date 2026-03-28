"""Grade level models."""
from sqlalchemy import Column, Integer, String, Text, DateTime, func
from sqlalchemy.orm import relationship

from app.database import Base


class Grade(Base):
    """Grade level model (6-12)."""
    __tablename__ = "grades"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    level = Column(Integer, unique=True, nullable=False)
    description = Column(Text)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    domains = relationship("Domain", back_populates="grade", cascade="all, delete-orphan")
    subjects = relationship("Subject", back_populates="grade", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Grade {self.name}>"
