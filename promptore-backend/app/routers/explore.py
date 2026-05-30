from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, text

from ..database import get_db
from ..models.prompt import Prompt

router = APIRouter()


@router.get("/categories")
async def get_categories(db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(
            Prompt.category,
            func.count().label("count"),
            func.max(Prompt.impact_score).label("top_impact"),
        )
        .group_by(Prompt.category)
        .order_by(func.count().desc())
    )
    rows = result.fetchall()
    return [
        {"category": row[0], "count": row[1], "top_impact": round(row[2] or 0, 2)}
        for row in rows
    ]


@router.get("/trending-tags")
async def get_trending_tags(db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        text(
            "SELECT tag, COUNT(*) as cnt "
            "FROM public.prompts, UNNEST(tags) AS tag "
            "GROUP BY tag ORDER BY cnt DESC LIMIT 20"
        )
    )
    rows = result.fetchall()
    return [{"tag": row[0], "count": row[1]} for row in rows]
