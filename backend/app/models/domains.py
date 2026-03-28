"""CA CCSS Domain models."""
from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey, func
from sqlalchemy.orm import relationship

from app.database import Base


class Domain(Base):
    """CA CCSS Domain model (RP, NS, EE, G, SP)."""
    __tablename__ = "domains"

    id = Column(Integer, primary_key=True, index=True)
    grade_id = Column(Integer, ForeignKey("grades.id", ondelete="CASCADE"), nullable=False)
    name = Column(String(200), nullable=False)
    code = Column(String(20), nullable=False)  # RP, NS, EE, G, SP
    description = Column(Text)
    order_index = Column(Integer, default=0)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    grade = relationship("Grade", back_populates="domains")
    clusters = relationship("Cluster", back_populates="domain", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Domain {self.code}: {self.name}>"


class Cluster(Base):
    """Cluster of related standards."""
    __tablename__ = "clusters"

    id = Column(Integer, primary_key=True, index=True)
    domain_id = Column(Integer, ForeignKey("domains.id", ondelete="CASCADE"), nullable=False)
    name = Column(String(300), nullable=False)
    description = Column(Text)
    order_index = Column(Integer, default=0)

    # Relationships
    domain = relationship("Domain", back_populates="clusters")
    standards = relationship("Standard", back_populates="cluster", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Cluster {self.name}>"


class Standard(Base):
    """Individual CA CCSS Standard."""
    __tablename__ = "standards"

    id = Column(Integer, primary_key=True, index=True)
    cluster_id = Column(Integer, ForeignKey("clusters.id", ondelete="CASCADE"), nullable=False)
    standard_code = Column(String(50), unique=True, nullable=False, index=True)  # 6.RP.1
    description = Column(Text, nullable=False)
    learning_objective = Column(Text)  # Student-facing: "I can..."
    is_major_work = Column(Integer, default=0)  # 1=True, 0=False
    is_california_addition = Column(Integer, default=0)
    order_index = Column(Integer, default=0)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    cluster = relationship("Cluster", back_populates="standards")
    topic_standards = relationship("TopicStandard", back_populates="standard")
    quiz_questions = relationship("QuizQuestion", back_populates="standard")
    standard_mastery = relationship("StandardMastery", back_populates="standard")

    def __repr__(self):
        return f"<Standard {self.standard_code}>"
