from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, delete
from datetime import datetime, timezone
import uuid

from ..database import get_db
from ..dependencies import get_current_user_id
from ..models.user import User
from ..models.prompt import Prompt
from ..models.collection import Collection, CollectionPrompt
from ..schemas.collection import CollectionCreate, CollectionResponse

router = APIRouter()


async def _build_collection_response(
    collection: Collection, db: AsyncSession
) -> CollectionResponse:
    result = await db.execute(
        select(CollectionPrompt.prompt_id).where(
            CollectionPrompt.collection_id == collection.id
        )
    )
    prompt_ids = [row[0] for row in result.fetchall()]
    return CollectionResponse(
        id=collection.id,
        name=collection.name,
        description=collection.description,
        owner_id=collection.owner_id,
        prompt_ids=prompt_ids,
        prompt_count=collection.prompt_count,
        cover_color=collection.cover_color,
        is_public=collection.is_public,
        created_at=collection.created_at,
    )


@router.get("", response_model=list[CollectionResponse])
async def get_my_collections(
    user_id: uuid.UUID = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Collection).where(Collection.owner_id == user_id)
    )
    collections = list(result.scalars().all())
    return [await _build_collection_response(c, db) for c in collections]


@router.post("", response_model=CollectionResponse, status_code=201)
async def create_collection(
    data: CollectionCreate,
    user_id: uuid.UUID = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    collection = Collection(
        name=data.name,
        description=data.description,
        owner_id=user_id,
        cover_color=data.cover_color,
        is_public=data.is_public,
        created_at=datetime.now(timezone.utc),
    )
    db.add(collection)

    user_result = await db.execute(select(User).where(User.id == user_id))
    user = user_result.scalar_one()
    user.collections_count += 1

    await db.commit()
    await db.refresh(collection)
    return await _build_collection_response(collection, db)


@router.delete("/{collection_id}")
async def delete_collection(
    collection_id: uuid.UUID,
    user_id: uuid.UUID = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Collection).where(Collection.id == collection_id)
    )
    collection = result.scalar_one_or_none()
    if not collection:
        raise HTTPException(status_code=404, detail="Collection not found")
    if collection.owner_id != user_id:
        raise HTTPException(status_code=403, detail="Not authorized")

    user_result = await db.execute(select(User).where(User.id == user_id))
    user = user_result.scalar_one()
    user.collections_count = max(0, user.collections_count - 1)

    await db.delete(collection)
    await db.commit()
    return {"deleted": True}


@router.post("/{collection_id}/prompts/{prompt_id}", response_model=CollectionResponse)
async def add_prompt_to_collection(
    collection_id: uuid.UUID,
    prompt_id: uuid.UUID,
    user_id: uuid.UUID = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Collection).where(Collection.id == collection_id)
    )
    collection = result.scalar_one_or_none()
    if not collection:
        raise HTTPException(status_code=404, detail="Collection not found")
    if collection.owner_id != user_id:
        raise HTTPException(status_code=403, detail="Not authorized")

    cp = CollectionPrompt(
        collection_id=collection_id,
        prompt_id=prompt_id,
        added_at=datetime.now(timezone.utc),
    )
    db.add(cp)
    collection.prompt_count += 1

    # Increment archive_count on prompt
    prompt_result = await db.execute(select(Prompt).where(Prompt.id == prompt_id))
    prompt = prompt_result.scalar_one_or_none()
    if prompt:
        prompt.archive_count += 1

    await db.commit()
    await db.refresh(collection)
    return await _build_collection_response(collection, db)


@router.delete(
    "/{collection_id}/prompts/{prompt_id}", response_model=CollectionResponse
)
async def remove_prompt_from_collection(
    collection_id: uuid.UUID,
    prompt_id: uuid.UUID,
    user_id: uuid.UUID = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Collection).where(Collection.id == collection_id)
    )
    collection = result.scalar_one_or_none()
    if not collection:
        raise HTTPException(status_code=404, detail="Collection not found")
    if collection.owner_id != user_id:
        raise HTTPException(status_code=403, detail="Not authorized")

    # Delete from junction table
    await db.execute(
        delete(CollectionPrompt).where(
            CollectionPrompt.collection_id == collection_id,
            CollectionPrompt.prompt_id == prompt_id,
        )
    )
    collection.prompt_count = max(0, collection.prompt_count - 1)

    await db.commit()
    await db.refresh(collection)
    return await _build_collection_response(collection, db)
