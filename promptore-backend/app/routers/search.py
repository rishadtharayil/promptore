from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, text
from datetime import datetime
from typing import Optional
import uuid

from ..database import get_db
from ..models.prompt import Prompt
from ..schemas.prompt import PromptResponse
from ..schemas.common import PaginatedResponse

router = APIRouter()


@router.get("", response_model=PaginatedResponse[PromptResponse])
async def search_prompts(
    q: str = Query(..., min_length=1),
    category: Optional[str] = Query(None),
    tags: Optional[str] = Query(None),
    cursor: Optional[str] = Query(None),
    limit: int = Query(20, ge=1, le=50),
    db: AsyncSession = Depends(get_db),
):
    ts_query = func.plainto_tsquery("english", q)

    stmt = select(Prompt).where(Prompt.search_vector.op("@@")(ts_query))

    if category:
        stmt = stmt.where(Prompt.category == category)

    if tags:
        tag_list = [t.strip() for t in tags.split(",")]
        stmt = stmt.where(Prompt.tags.op("@>")(tag_list))

    if cursor:
        stmt = stmt.where(Prompt.created_at < datetime.fromisoformat(cursor))

    stmt = stmt.order_by(
        func.ts_rank(Prompt.search_vector, ts_query).desc()
    ).limit(limit)

    result = await db.execute(stmt)
    prompts = list(result.scalars().all())

    # Build responses
    from .prompts import _build_prompt_response

    data = [await _build_prompt_response(p, db) for p in prompts]
    next_cursor = prompts[-1].created_at.isoformat() if len(prompts) == limit else None
    return PaginatedResponse(
        data=data, next_cursor=next_cursor, has_more=next_cursor is not None
    )
