"""API v1 routes."""
from fastapi import APIRouter

from app.api.v1 import grades, subjects, topics, auth, quiz

api_router = APIRouter(prefix="/v1")

api_router.include_router(auth.router, prefix="/auth", tags=["authentication"])
api_router.include_router(grades.router, prefix="/grades", tags=["grades"])
api_router.include_router(subjects.router, prefix="/subjects", tags=["subjects"])
api_router.include_router(topics.router, prefix="/topics", tags=["topics"])
api_router.include_router(quiz.router, prefix="/quiz", tags=["quiz"])
