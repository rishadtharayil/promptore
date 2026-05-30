from pydantic import BaseModel
from typing import Optional
from datetime import datetime
import uuid


class CollectionCreate(BaseModel):
    name: str
    description: Optional[str] = None
    cover_color: Optional[str] = "#5A6B8B"
    is_public: bool = True


class CollectionResponse(BaseModel):
    id: uuid.UUID
    name: str
    description: Optional[str] = None
    owner_id: uuid.UUID
    prompt_ids: list[uuid.UUID] = []
    prompt_count: int
    cover_color: Optional[str] = None
    is_public: bool
    created_at: datetime

    model_config = {"from_attributes": True}
