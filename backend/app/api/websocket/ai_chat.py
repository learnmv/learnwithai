"""WebSocket endpoint for real-time AI chat."""
import json
from typing import List
from datetime import datetime
from uuid import UUID

from fastapi import APIRouter, WebSocket, WebSocketDisconnect, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, desc

from app.database import get_async_session
from app.models.chat_history import ChatHistory
from app.models.users import User
from app.services.ai_service import AIService

router = APIRouter()


class ConnectionManager:
    """Manage WebSocket connections."""

    def __init__(self):
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        if websocket in self.active_connections:
            self.active_connections.remove(websocket)

    async def send_message(self, websocket: WebSocket, message: dict):
        await websocket.send_json(message)


manager = ConnectionManager()


@router.websocket("/ws/ai-chat")
async def ai_chat_websocket(
    websocket: WebSocket,
    db: AsyncSession = Depends(get_async_session)
):
    """WebSocket endpoint for real-time AI chat."""
    await manager.connect(websocket)
    ai_service = AIService()

    try:
        while True:
            # Receive message from client
            data = await websocket.receive_json()
            user_message = data.get("message")
            topic_id = data.get("topic_id")
            session_id = data.get("session_id")
            user_id = data.get("user_id")  # In production, validate JWT token

            if not user_id:
                await manager.send_message(websocket, {
                    "type": "error",
                    "message": "Authentication required"
                })
                continue

            # Get chat history for context
            chat_history = []
            if session_id:
                result = await db.execute(
                    select(ChatHistory)
                    .where(ChatHistory.session_id == UUID(session_id))
                    .order_by(desc(ChatHistory.created_at))
                    .limit(5)
                )
                recent_chats = result.scalars().all()
                chat_history = [
                    {"role": chat.message_role, "content": chat.message_content}
                    for chat in reversed(recent_chats)
                ]

            # Get topic name for context
            topic_name = "this topic"
            if topic_id:
                from app.models.topics import Topic
                topic_result = await db.execute(
                    select(Topic).where(Topic.id == topic_id)
                )
                topic = topic_result.scalar_one_or_none()
                if topic:
                    topic_name = topic.name

            # Stream AI response
            full_response = ""
            session_uuid = UUID(session_id) if session_id else None

            async for chunk in ai_service.chat(
                message=user_message,
                context={
                    "topic_name": topic_name,
                    "chat_history": chat_history
                }
            ):
                full_response += chunk
                await manager.send_message(websocket, {
                    "type": "ai_chunk",
                    "content": chunk,
                    "session_id": str(session_uuid) if session_uuid else None
                })

            # Send completion signal
            await manager.send_message(websocket, {
                "type": "ai_complete",
                "full_message": full_response,
                "session_id": str(session_uuid) if session_uuid else None
            })

            # Save to database
            user_uuid = UUID(user_id)
            topic_uuid = int(topic_id) if topic_id else None

            if not session_uuid:
                session_uuid = UUID("12345678-1234-1234-1234-123456789abc")  # Generate new

            # Save user message
            user_chat = ChatHistory(
                user_id=user_uuid,
                topic_id=topic_uuid,
                session_id=session_uuid,
                message_role="user",
                message_content=user_message,
                model_used="llama3.2"
            )
            db.add(user_chat)

            # Save AI response
            ai_chat = ChatHistory(
                user_id=user_uuid,
                topic_id=topic_uuid,
                session_id=session_uuid,
                message_role="assistant",
                message_content=full_response,
                model_used="llama3.2"
            )
            db.add(ai_chat)

            await db.commit()

    except WebSocketDisconnect:
        manager.disconnect(websocket)
        await ai_service.close()
    except Exception as e:
        await manager.send_message(websocket, {
            "type": "error",
            "message": str(e)
        })
        manager.disconnect(websocket)
        await ai_service.close()
