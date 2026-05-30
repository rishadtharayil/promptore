from pydantic import BaseModel
from datetime import datetime
import uuid


class AnnotationCreate(BaseModel):
    content: str


class AnnotationResponse(BaseModel):
    id: uuid.UUID
    prompt_id: uuid.UUID
    author_id: uuid.UUID
    author_name: str
    author_handle: str
    content: str
    created_at: datetime

    model_config = {"from_attributes": True}
