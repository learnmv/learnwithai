"""AI chat history model."""
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Text, JSON, func, func
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
import uuid

from app.database import Base


class ChatHistory(Base):
    """AI chat conversation history."""
    __tablename__ = "chat_history"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    topic_id = Column(Integer, ForeignKey("topics.id", ondelete="SET NULL"))
    session_id = Column(UUID(as_uuid=True), default=uuid.uuid4)
    message_role = Column(String(20), nullable=False)  # 'user' or 'assistant'
    message_content = Column(Text, nullable=False)
    context = Column(JSON)  # Topic context, previous messages
    tokens_used = Column(Integer)
    model_used = Column(String(100))  # e.g., 'llama3.2'
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    user = relationship("User", back_populates="chat_history")
    topic = relationship("Topic", back_populates="chat_history")

    def __repr__(self):
        return f"<ChatHistory {self.id}: {self.message_role}>"
