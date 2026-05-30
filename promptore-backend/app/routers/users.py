from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from datetime import datetime, timezone
from typing import Optional
import uuid

from ..database import get_db
from ..dependencies import get_current_user_id
from ..models.user import User
from ..models.prompt import Prompt
from ..models.associations import follows
from ..schemas.user import UserUpdate, UserResponse
from ..schemas.prompt import PromptResponse
from ..schemas.common import PaginatedResponse

router = APIRouter()


def _user_to_response(user: User, is_tuned_in: bool = False) -> UserResponse:
    return UserResponse(
        id=user.id,
        display_name=user.display_name,
        handle=user.handle,
        bio=user.bio,
        avatar_url=user.avatar_url,
        mood=user.mood,
        prompt_count=user.prompt_count,
        echoes_received=user.echoes_received,
        collections_count=user.collections_count,
        tuned_in_count=user.tuned_in_count,
        tuning_in_to_count=user.tuning_in_to_count,
        joined_at=user.joined_at,
        pinned_prompt_ids=user.pinned_prompt_ids or [],
        is_tuned_in=is_tuned_in,
    )


@router.get("/me", response_model=UserResponse)
async def get_me(
    user_id: uuid.UUID = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return _user_to_response(user, is_tuned_in=False)


@router.put("/me", response_model=UserResponse)
async def update_me(
    data: UserUpdate,
    user_id: uuid.UUID = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    update_data = data.model_dump(exclude_unset=True)

    # Check handle uniqueness
    if "handle" in update_data and update_data["handle"] != user.handle:
        existing = await db.execute(
            select(User).where(User.handle == update_data["handle"])
        )
        if existing.scalar_one_or_none():
            raise HTTPException(status_code=409, detail="Handle already taken")

    for key, value in update_data.items():
        setattr(user, key, value)

    await db.commit()
    await db.refresh(user)
    return _user_to_response(user, is_tuned_in=False)


@router.get("/{user_id}", response_model=UserResponse)
async def get_user(
    user_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return _user_to_response(user)


@router.get("/{user_id}/prompts", response_model=PaginatedResponse[PromptResponse])
async def get_user_prompts(
    user_id: uuid.UUID,
    cursor: Optional[str] = Query(None),
    limit: int = Query(20, ge=1, le=50),
    db: AsyncSession = Depends(get_db),
):
    stmt = select(Prompt).where(Prompt.author_id == user_id)
    if cursor:
        stmt = stmt.where(Prompt.created_at < datetime.fromisoformat(cursor))
    stmt = stmt.order_by(Prompt.created_at.desc()).limit(limit)

    result = await db.execute(stmt)
    prompts = list(result.scalars().all())

    from .prompts import _build_prompt_response

    data = [await _build_prompt_response(p, db) for p in prompts]
    next_cursor = prompts[-1].created_at.isoformat() if len(prompts) == limit else None
    return PaginatedResponse(
        data=data, next_cursor=next_cursor, has_more=next_cursor is not None
    )


@router.post("/{target_user_id}/follow")
async def follow_user(
    target_user_id: uuid.UUID,
    user_id: uuid.UUID = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    if user_id == target_user_id:
        raise HTTPException(status_code=400, detail="Cannot follow yourself")

    existing = await db.execute(
        select(follows).where(
            follows.c.follower_id == user_id,
            follows.c.following_id == target_user_id,
        )
    )
    if existing.first():
        raise HTTPException(status_code=409, detail="Already following")

    await db.execute(
        follows.insert().values(
            follower_id=user_id,
            following_id=target_user_id,
            created_at=datetime.now(timezone.utc),
        )
    )

    # Update counts
    target_result = await db.execute(
        select(User).where(User.id == target_user_id)
    )
    target = target_result.scalar_one()
    target.tuned_in_count += 1

    me_result = await db.execute(select(User).where(User.id == user_id))
    me = me_result.scalar_one()
    me.tuning_in_to_count += 1

    await db.commit()
    return {"following": True}


@router.delete("/{target_user_id}/follow")
async def unfollow_user(
    target_user_id: uuid.UUID,
    user_id: uuid.UUID = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    await db.execute(
        follows.delete().where(
            follows.c.follower_id == user_id,
            follows.c.following_id == target_user_id,
        )
    )

    target_result = await db.execute(
        select(User).where(User.id == target_user_id)
    )
    target = target_result.scalar_one_or_none()
    if target:
        target.tuned_in_count = max(0, target.tuned_in_count - 1)

    me_result = await db.execute(select(User).where(User.id == user_id))
    me = me_result.scalar_one()
    me.tuning_in_to_count = max(0, me.tuning_in_to_count - 1)

    await db.commit()
    return {"following": False}
