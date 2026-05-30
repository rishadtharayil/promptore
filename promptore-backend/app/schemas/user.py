from pydantic import BaseModel
from typing import Optional
from datetime import datetime
import uuid


class UserUpdate(BaseModel):
    display_name: Optional[str] = None
    handle: Optional[str] = None
    bio: Optional[str] = None
    mood: Optional[str] = None
    avatar_url: Optional[str] = None


class UserResponse(BaseModel):
    id: uuid.UUID
    display_name: str
    handle: str
    bio: Optional[str] = None
    avatar_url: Optional[str] = None
    mood: Optional[str] = None
    prompt_count: int
    echoes_received: int
    collections_count: int
    tuned_in_count: int
    tuning_in_to_count: int
    joined_at: datetime
    pinned_prompt_ids: list[uuid.UUID]
    is_tuned_in: bool = False

    model_config = {"from_attributes": True}
