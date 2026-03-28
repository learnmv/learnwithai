"""API dependencies."""
from typing import AsyncGenerator

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_async_session
from app.services.ai_service import AIService


async def get_db() -> AsyncGenerator[AsyncSession, None]:
    """Get database session."""
    async for session in get_async_session():
        yield session


async def get_ai_service() -> AIService:
    """Get AI service instance."""
    service = AIService()
    try:
        yield service
    finally:
        await service.close()
