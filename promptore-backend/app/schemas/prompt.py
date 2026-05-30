from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime
import uuid


class PromptCreate(BaseModel):
    title: str = Field(..., max_length=300)
    excerpt: str
    content: str
    category: str
    tags: list[str] = []
    size: str = "medium"
    remix_of_id: Optional[uuid.UUID] = None
    remix_of_title: Optional[str] = None


class PromptUpdate(BaseModel):
    title: Optional[str] = None
    excerpt: Optional[str] = None
    content: Optional[str] = None
    tags: Optional[list[str]] = None


class PromptResponse(BaseModel):
    id: uuid.UUID
    title: str
    excerpt: str
    content: str
    author_id: uuid.UUID
    author_name: str
    author_handle: str
    author_avatar_url: Optional[str] = None
    category: str
    tags: list[str]
    echo_count: int
    archive_count: int
    remix_count: int
    annotation_count: int
    remix_of_id: Optional[uuid.UUID] = None
    remix_of_title: Optional[str] = None
    thumbnail_url: Optional[str] = None
    size: str
    impact_score: float
    created_at: datetime
    updated_at: Optional[datetime] = None
    is_echoed: bool = False
    is_archived: bool = False

    model_config = {"from_attributes": True}
