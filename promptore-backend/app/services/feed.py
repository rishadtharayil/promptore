from datetime import datetime
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, desc
from ..models.prompt import Prompt
from ..models.associations import follows
import uuid
from typing import Optional


async def get_followed_ids(db: AsyncSession, user_id: uuid.UUID) -> list[uuid.UUID]:
    result = await db.execute(
        select(follows.c.following_id).where(follows.c.follower_id == user_id)
    )
    return [row[0] for row in result.fetchall()]


async def get_prompts_from_users(
    db: AsyncSession,
    user_ids: list[uuid.UUID],
    cursor: Optional[datetime],
    limit: int,
    exclude_prompt_ids: list[uuid.UUID],
) -> list[Prompt]:
    stmt = select(Prompt).where(Prompt.author_id.in_(user_ids))
    if cursor:
        stmt = stmt.where(Prompt.created_at < cursor)
    if exclude_prompt_ids:
        stmt = stmt.where(Prompt.id.notin_(exclude_prompt_ids))
    stmt = stmt.order_by(desc(Prompt.impact_score)).limit(limit)
    result = await db.execute(stmt)
    return list(result.scalars().all())


async def get_trending_prompts(
    db: AsyncSession,
    exclude_user_ids: list[uuid.UUID],
    exclude_prompt_ids: list[uuid.UUID],
    cursor: Optional[datetime],
    limit: int,
) -> list[Prompt]:
    stmt = select(Prompt)
    if exclude_user_ids:
        stmt = stmt.where(Prompt.author_id.notin_(exclude_user_ids))
    if cursor:
        stmt = stmt.where(Prompt.created_at < cursor)
    if exclude_prompt_ids:
        stmt = stmt.where(Prompt.id.notin_(exclude_prompt_ids))
    stmt = stmt.order_by(desc(Prompt.impact_score)).limit(limit)
    result = await db.execute(stmt)
    return list(result.scalars().all())


def interleave_prompts(a: list[Prompt], b: list[Prompt]) -> list[Prompt]:
    result = []
    i, j = 0, 0
    while i < len(a) and j < len(b):
        result.append(a[i])
        i += 1
        result.append(b[j])
        j += 1
    result.extend(a[i:])
    result.extend(b[j:])
    return result


async def get_personalized_feed(
    db: AsyncSession,
    current_user_id: uuid.UUID,
    cursor: Optional[datetime],
    limit: int = 20,
) -> tuple[list[Prompt], Optional[datetime]]:
    followed_ids = await get_followed_ids(db, current_user_id)

    if followed_ids:
        personalized_limit = int(limit * 0.6)
        discovery_limit = limit - personalized_limit

        personalized = await get_prompts_from_users(
            db,
            user_ids=followed_ids,
            cursor=cursor,
            limit=personalized_limit,
            exclude_prompt_ids=[],
        )

        exclude_ids = [p.id for p in personalized]
        exclude_user_ids = followed_ids + [current_user_id]
        discovery = await get_trending_prompts(
            db,
            exclude_user_ids=exclude_user_ids,
            exclude_prompt_ids=exclude_ids,
            cursor=cursor,
            limit=discovery_limit,
        )

        feed = interleave_prompts(personalized, discovery)
    else:
        feed = await get_trending_prompts(
            db,
            exclude_user_ids=[current_user_id],
            exclude_prompt_ids=[],
            cursor=cursor,
            limit=limit,
        )

    next_cursor = feed[-1].created_at if len(feed) == limit else None
    return feed, next_cursor
