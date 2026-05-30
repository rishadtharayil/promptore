from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from datetime import datetime, timezone
from typing import Optional
import uuid

from ..database import get_db
from ..dependencies import get_current_user_id, get_current_user, bearer_scheme
from ..models.user import User
from ..models.prompt import Prompt
from ..models.associations import echoes, archives
from ..schemas.prompt import PromptCreate, PromptUpdate, PromptResponse
from ..schemas.common import PaginatedResponse
from ..services.impact_score import compute_impact_score
from ..services.feed import get_personalized_feed
from fastapi.security import HTTPAuthorizationCredentials

router = APIRouter()


async def _build_prompt_response(
    prompt: Prompt, db: AsyncSession, user_id: Optional[uuid.UUID] = None
) -> PromptResponse:
    """Build a PromptResponse from a Prompt ORM model, including author info and user-specific flags."""
    # Get author info
    author_result = await db.execute(select(User).where(User.id == prompt.author_id))
    author = author_result.scalar_one_or_none()
    author_name = author.display_name if author else "Unknown"
    author_handle = author.handle if author else "unknown"
    author_avatar_url = author.avatar_url if author else None

    is_echoed = False
    is_archived = False
    if user_id:
        echo_result = await db.execute(
            select(echoes).where(
                echoes.c.user_id == user_id, echoes.c.prompt_id == prompt.id
            )
        )
        is_echoed = echo_result.first() is not None

        archive_result = await db.execute(
            select(archives).where(
                archives.c.user_id == user_id, archives.c.prompt_id == prompt.id
            )
        )
        is_archived = archive_result.first() is not None

    return PromptResponse(
        id=prompt.id,
        title=prompt.title,
        excerpt=prompt.excerpt,
        content=prompt.content,
        author_id=prompt.author_id,
        author_name=author_name,
        author_handle=author_handle,
        author_avatar_url=author_avatar_url,
        category=prompt.category,
        tags=prompt.tags or [],
        echo_count=prompt.echo_count,
        archive_count=prompt.archive_count,
        remix_count=prompt.remix_count,
        annotation_count=prompt.annotation_count,
        remix_of_id=prompt.remix_of_id,
        remix_of_title=prompt.remix_of_title,
        thumbnail_url=prompt.thumbnail_url,
        size=prompt.size,
        impact_score=prompt.impact_score,
        created_at=prompt.created_at,
        updated_at=prompt.updated_at,
        is_echoed=is_echoed,
        is_archived=is_archived,
    )


# ──────────────────── FEED ────────────────────
@router.get("/feed", response_model=PaginatedResponse[PromptResponse])
async def get_feed(
    cursor: Optional[str] = Query(None),
    limit: int = Query(20, ge=1, le=50),
    user_id: uuid.UUID = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    cursor_dt = datetime.fromisoformat(cursor) if cursor else None
    prompts, next_cursor = await get_personalized_feed(db, user_id, cursor_dt, limit)

    data = [await _build_prompt_response(p, db, user_id) for p in prompts]
    return PaginatedResponse(
        data=data,
        next_cursor=next_cursor.isoformat() if next_cursor else None,
        has_more=next_cursor is not None,
    )


# ──────────────────── TRENDING ────────────────────
@router.get("/trending", response_model=PaginatedResponse[PromptResponse])
async def get_trending(
    cursor: Optional[str] = Query(None),
    limit: int = Query(20, ge=1, le=50),
    category: Optional[str] = Query(None),
    db: AsyncSession = Depends(get_db),
):
    stmt = select(Prompt)
    if category:
        stmt = stmt.where(Prompt.category == category)
    if cursor:
        cursor_dt = datetime.fromisoformat(cursor)
        stmt = stmt.where(Prompt.created_at < cursor_dt)
    stmt = stmt.order_by(Prompt.impact_score.desc()).limit(limit)

    result = await db.execute(stmt)
    prompts = list(result.scalars().all())

    data = [await _build_prompt_response(p, db) for p in prompts]
    next_cursor = prompts[-1].created_at.isoformat() if len(prompts) == limit else None
    return PaginatedResponse(
        data=data,
        next_cursor=next_cursor,
        has_more=next_cursor is not None,
    )


# ──────────────────── GET SINGLE ────────────────────
@router.get("/{prompt_id}", response_model=PromptResponse)
async def get_prompt(
    prompt_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(Prompt).where(Prompt.id == prompt_id))
    prompt = result.scalar_one_or_none()
    if not prompt:
        raise HTTPException(status_code=404, detail="Prompt not found")
    return await _build_prompt_response(prompt, db)


# ──────────────────── CREATE ────────────────────
@router.post("", response_model=PromptResponse, status_code=201)
async def create_prompt(
    data: PromptCreate,
    user_id: uuid.UUID = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    now = datetime.now(timezone.utc)
    prompt = Prompt(
        title=data.title,
        excerpt=data.excerpt,
        content=data.content,
        author_id=user_id,
        category=data.category,
        tags=data.tags,
        size=data.size,
        remix_of_id=data.remix_of_id,
        remix_of_title=data.remix_of_title,
        impact_score=0.0,
        created_at=now,
    )
    db.add(prompt)

    # If remix, increment remix_count on original
    if data.remix_of_id:
        original_result = await db.execute(
            select(Prompt).where(Prompt.id == data.remix_of_id)
        )
        original = original_result.scalar_one_or_none()
        if original:
            original.remix_count += 1
            original.impact_score = compute_impact_score(
                original.echo_count,
                original.archive_count,
                original.remix_count,
                original.annotation_count,
                original.created_at,
            )

    # Increment user prompt count
    user_result = await db.execute(select(User).where(User.id == user_id))
    user = user_result.scalar_one()
    user.prompt_count += 1

    await db.commit()
    await db.refresh(prompt)
    return await _build_prompt_response(prompt, db, user_id)


# ──────────────────── UPDATE ────────────────────
@router.put("/{prompt_id}", response_model=PromptResponse)
async def update_prompt(
    prompt_id: uuid.UUID,
    data: PromptUpdate,
    user_id: uuid.UUID = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(Prompt).where(Prompt.id == prompt_id))
    prompt = result.scalar_one_or_none()
    if not prompt:
        raise HTTPException(status_code=404, detail="Prompt not found")
    if prompt.author_id != user_id:
        raise HTTPException(status_code=403, detail="Not authorized")

    update_data = data.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(prompt, key, value)
    prompt.updated_at = datetime.now(timezone.utc)

    await db.commit()
    await db.refresh(prompt)
    return await _build_prompt_response(prompt, db, user_id)


# ──────────────────── DELETE ────────────────────
@router.delete("/{prompt_id}")
async def delete_prompt(
    prompt_id: uuid.UUID,
    user_id: uuid.UUID = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(Prompt).where(Prompt.id == prompt_id))
    prompt = result.scalar_one_or_none()
    if not prompt:
        raise HTTPException(status_code=404, detail="Prompt not found")
    if prompt.author_id != user_id:
        raise HTTPException(status_code=403, detail="Not authorized")

    # Decrement user prompt count
    user_result = await db.execute(select(User).where(User.id == user_id))
    user = user_result.scalar_one()
    user.prompt_count = max(0, user.prompt_count - 1)

    await db.delete(prompt)
    await db.commit()
    return {"deleted": True}


# ──────────────────── REMIXES ────────────────────
@router.get("/{prompt_id}/remixes", response_model=PaginatedResponse[PromptResponse])
async def get_remixes(
    prompt_id: uuid.UUID,
    cursor: Optional[str] = Query(None),
    limit: int = Query(20, ge=1, le=50),
    db: AsyncSession = Depends(get_db),
):
    stmt = select(Prompt).where(Prompt.remix_of_id == prompt_id)
    if cursor:
        stmt = stmt.where(Prompt.created_at < datetime.fromisoformat(cursor))
    stmt = stmt.order_by(Prompt.created_at.desc()).limit(limit)

    result = await db.execute(stmt)
    prompts = list(result.scalars().all())
    data = [await _build_prompt_response(p, db) for p in prompts]
    next_cursor = prompts[-1].created_at.isoformat() if len(prompts) == limit else None
    return PaginatedResponse(
        data=data, next_cursor=next_cursor, has_more=next_cursor is not None
    )


# ──────────────────── ECHO ────────────────────
@router.post("/{prompt_id}/echo")
async def echo_prompt(
    prompt_id: uuid.UUID,
    user_id: uuid.UUID = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    # Check if already echoed
    existing = await db.execute(
        select(echoes).where(
            echoes.c.user_id == user_id, echoes.c.prompt_id == prompt_id
        )
    )
    if existing.first():
        raise HTTPException(status_code=409, detail="Already echoed")

    # Insert echo
    await db.execute(
        echoes.insert().values(
            user_id=user_id,
            prompt_id=prompt_id,
            created_at=datetime.now(timezone.utc),
        )
    )

    # Update counts
    result = await db.execute(select(Prompt).where(Prompt.id == prompt_id))
    prompt = result.scalar_one()
    prompt.echo_count += 1
    prompt.impact_score = compute_impact_score(
        prompt.echo_count,
        prompt.archive_count,
        prompt.remix_count,
        prompt.annotation_count,
        prompt.created_at,
    )

    # Increment echoes_received on author
    author_result = await db.execute(select(User).where(User.id == prompt.author_id))
    author = author_result.scalar_one()
    author.echoes_received += 1

    await db.commit()
    return {"echoed": True, "echo_count": prompt.echo_count}


@router.delete("/{prompt_id}/echo")
async def unecho_prompt(
    prompt_id: uuid.UUID,
    user_id: uuid.UUID = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    await db.execute(
        echoes.delete().where(
            echoes.c.user_id == user_id, echoes.c.prompt_id == prompt_id
        )
    )

    result = await db.execute(select(Prompt).where(Prompt.id == prompt_id))
    prompt = result.scalar_one()
    prompt.echo_count = max(0, prompt.echo_count - 1)
    prompt.impact_score = compute_impact_score(
        prompt.echo_count,
        prompt.archive_count,
        prompt.remix_count,
        prompt.annotation_count,
        prompt.created_at,
    )

    author_result = await db.execute(select(User).where(User.id == prompt.author_id))
    author = author_result.scalar_one()
    author.echoes_received = max(0, author.echoes_received - 1)

    await db.commit()
    return {"echoed": False, "echo_count": prompt.echo_count}


# ──────────────────── ARCHIVE ────────────────────
@router.post("/{prompt_id}/archive")
async def archive_prompt(
    prompt_id: uuid.UUID,
    user_id: uuid.UUID = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    existing = await db.execute(
        select(archives).where(
            archives.c.user_id == user_id, archives.c.prompt_id == prompt_id
        )
    )
    if existing.first():
        raise HTTPException(status_code=409, detail="Already archived")

    await db.execute(
        archives.insert().values(
            user_id=user_id,
            prompt_id=prompt_id,
            created_at=datetime.now(timezone.utc),
        )
    )

    result = await db.execute(select(Prompt).where(Prompt.id == prompt_id))
    prompt = result.scalar_one()
    prompt.archive_count += 1
    prompt.impact_score = compute_impact_score(
        prompt.echo_count,
        prompt.archive_count,
        prompt.remix_count,
        prompt.annotation_count,
        prompt.created_at,
    )

    await db.commit()
    return {"archived": True, "archive_count": prompt.archive_count}


@router.delete("/{prompt_id}/archive")
async def unarchive_prompt(
    prompt_id: uuid.UUID,
    user_id: uuid.UUID = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    await db.execute(
        archives.delete().where(
            archives.c.user_id == user_id, archives.c.prompt_id == prompt_id
        )
    )

    result = await db.execute(select(Prompt).where(Prompt.id == prompt_id))
    prompt = result.scalar_one()
    prompt.archive_count = max(0, prompt.archive_count - 1)
    prompt.impact_score = compute_impact_score(
        prompt.echo_count,
        prompt.archive_count,
        prompt.remix_count,
        prompt.annotation_count,
        prompt.created_at,
    )

    await db.commit()
    return {"archived": False, "archive_count": prompt.archive_count}
