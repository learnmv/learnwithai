"""AI service for Ollama integration."""
import json
from typing import AsyncGenerator, Optional, List

import httpx

from app.config import get_settings

settings = get_settings()


class AIService:
    """Service for interacting with Ollama local LLM."""

    def __init__(self, base_url: str = None):
        self.base_url = base_url or settings.ollama_base_url
        self.client = httpx.AsyncClient(timeout=60.0)

    async def chat(
        self,
        message: str,
        context: Optional[dict] = None,
        model: str = None
    ) -> AsyncGenerator[str, None]:
        """Stream chat response from Ollama."""
        model = model or settings.default_model

        # Build educational system prompt
        system_prompt = self._build_educational_prompt(context)

        # Build message history
        messages = [{"role": "system", "content": system_prompt}]

        if context and "chat_history" in context:
            for chat in context["chat_history"]:
                messages.append({"role": chat["role"], "content": chat["content"]})

        messages.append({"role": "user", "content": message})

        # Call Ollama API
        try:
            response = await self.client.post(
                f"{self.base_url}/api/chat",
                json={
                    "model": model,
                    "messages": messages,
                    "stream": True,
                    "options": {
                        "temperature": 0.7,
                        "top_p": 0.9,
                        "num_ctx": 4096
                    }
                }
            )

            async for line in response.aiter_lines():
                if line:
                    try:
                        data = json.loads(line)
                        if "message" in data and "content" in data["message"]:
                            yield data["message"]["content"]
                    except json.JSONDecodeError:
                        continue

        except httpx.RequestError as e:
            yield f"Error connecting to AI service: {str(e)}"

    def _build_educational_prompt(self, context: Optional[dict]) -> str:
        """Build system prompt for Socratic learning."""
        topic = context.get("topic_name", "this topic") if context else "this topic"

        return f"""You are Sprout, an AI learning companion for students studying {topic}.

CORE PRINCIPLES:
- Use the Socratic method: guide with questions, don't give direct answers
- Encourage critical thinking and exploration
- Break complex concepts into manageable steps
- Celebrate effort and progress
- Provide hints when students are stuck, never full solutions

RESPONSE STYLE:
- Warm, encouraging, patient
- Use analogies and real-world examples
- Keep responses concise (2-4 sentences)
- End with a thought-provoking question

Remember: Help students discover answers themselves!"""

    async def generate_quiz_question(
        self,
        topic: str,
        standard_code: Optional[str],
        difficulty: int,
        previous_questions: List[str]
    ) -> dict:
        """Generate adaptive quiz question using AI."""

        difficulty_text = ["easy", "medium", "hard"][difficulty - 1]

        prompt = f"""Generate a {difficulty_text} math question about {topic}.

Requirements:
- Multiple choice with 4 options
- Only ONE correct answer
- Clear, unambiguous wording
- Grade-appropriate for California Common Core
{f"- Aligned to standard: {standard_code}" if standard_code else ""}

Return ONLY valid JSON in this exact format:
{{
    "question": "question text",
    "options": ["option A", "option B", "option C", "option D"],
    "correct_index": 0,
    "explanation": "explanation of correct answer"
}}

Avoid these previous questions: {previous_questions[-5:] if previous_questions else "none"}"""

        try:
            response = await self.client.post(
                f"{self.base_url}/api/generate",
                json={
                    "model": settings.quiz_model,
                    "prompt": prompt,
                    "format": "json",
                    "options": {"temperature": 0.8}
                }
            )

            result = response.json()
            return json.loads(result["response"])

        except Exception as e:
            # Fallback question
            return {
                "question": f"What is 2 + 2?",
                "options": ["3", "4", "5", "6"],
                "correct_index": 1,
                "explanation": "2 + 2 = 4"
            }

    async def analyze_learning(
        self,
        user_responses: List[dict],
        standards: List[str]
    ) -> dict:
        """Analyze quiz responses to identify weak areas."""

        prompt = f"""Analyze these quiz responses and identify learning patterns.

Standards covered: {standards}
Responses: {json.dumps(user_responses)}

Provide:
1. Strong areas (standards mastered)
2. Weak areas (needs practice)
3. Personalized recommendation

Return JSON:
{{
    "strong_areas": ["standard_code"],
    "weak_areas": ["standard_code"],
    "recommendations": "advice for student"
}}"""

        try:
            response = await self.client.post(
                f"{self.base_url}/api/generate",
                json={
                    "model": settings.default_model,
                    "prompt": prompt,
                    "format": "json"
                }
            )

            result = response.json()
            return json.loads(result["response"])

        except Exception:
            return {
                "strong_areas": [],
                "weak_areas": standards[:2] if standards else [],
                "recommendations": "Keep practicing! Focus on understanding the concepts step by step."
            }

    async def close(self):
        """Close HTTP client."""
        await self.client.aclose()
