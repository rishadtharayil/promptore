from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from datetime import datetime, timezone
import uuid

from ..database import get_db
from ..dependencies import get_current_user_id
from ..models.user import User
from ..models.prompt import Prompt
from ..models.annotation import Annotation
from ..schemas.annotation import AnnotationCreate, AnnotationResponse
from ..services.impact_score import compute_impact_score

router = APIRouter()


@router.get(
    "/prompts/{prompt_id}/annotations", response_model=list[AnnotationResponse]
)
async def get_annotations(
    prompt_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Annotation)
        .where(Annotation.prompt_id == prompt_id)
        .order_by(Annotation.created_at.asc())
    )
    annotations = list(result.scalars().all())

    responses = []
    for ann in annotations:
        author_result = await db.execute(select(User).where(User.id == ann.author_id))
        author = author_result.scalar_one_or_none()
        responses.append(
            AnnotationResponse(
                id=ann.id,
                prompt_id=ann.prompt_id,
                author_id=ann.author_id,
                author_name=author.display_name if author else "Unknown",
                author_handle=author.handle if author else "unknown",
                content=ann.content,
                created_at=ann.created_at,
            )
        )
    return responses


@router.post(
    "/prompts/{prompt_id}/annotations",
    response_model=AnnotationResponse,
    status_code=201,
)
async def create_annotation(
    prompt_id: uuid.UUID,
    data: AnnotationCreate,
    user_id: uuid.UUID = Depends(get_current_user_id),
    db: AsyncSession = Depends(get_db),
):
    # Verify prompt exists
    prompt_result = await db.execute(select(Prompt).where(Prompt.id == prompt_id))
    prompt = prompt_result.scalar_one_or_none()
    if not prompt:
        raise HTTPException(status_code=404, detail="Prompt not found")

    annotation = Annotation(
        prompt_id=prompt_id,
        author_id=user_id,
        content=data.content,
        created_at=datetime.now(timezone.utc),
    )
    db.add(annotation)

    # Increment annotation count and recompute impact
    prompt.annotation_count += 1
    prompt.impact_score = compute_impact_score(
        prompt.echo_count,
        prompt.archive_count,
        prompt.remix_count,
        prompt.annotation_count,
        prompt.created_at,
    )

    await db.commit()
    await db.refresh(annotation)

    # Get author info
    author_result = await db.execute(select(User).where(User.id == user_id))
    author = author_result.scalar_one()

    return AnnotationResponse(
        id=annotation.id,
        prompt_id=annotation.prompt_id,
        author_id=annotation.author_id,
        author_name=author.display_name,
        author_handle=author.handle,
        content=annotation.content,
        created_at=annotation.created_at,
    )
