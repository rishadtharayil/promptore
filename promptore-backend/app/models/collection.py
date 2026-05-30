from sqlalchemy import String, Integer, Text, Boolean, TIMESTAMP, ForeignKey
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column
from datetime import datetime
from ..database import Base
import uuid


class Collection(Base):
    __tablename__ = "collections"
    __table_args__ = {"schema": "public"}

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name: Mapped[str] = mapped_column(String(200))
    description: Mapped[str | None] = mapped_column(Text)
    owner_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("public.users.id"))
    prompt_count: Mapped[int] = mapped_column(Integer, default=0)
    cover_color: Mapped[str | None] = mapped_column(String(20), default="#5A6B8B")
    is_public: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(TIMESTAMP(timezone=True))


class CollectionPrompt(Base):
    __tablename__ = "collection_prompts"
    __table_args__ = {"schema": "public"}

    collection_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("public.collections.id"), primary_key=True)
    prompt_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("public.prompts.id"), primary_key=True)
    added_at: Mapped[datetime] = mapped_column(TIMESTAMP(timezone=True))
