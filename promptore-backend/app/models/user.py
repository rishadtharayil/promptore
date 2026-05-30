from sqlalchemy import String, Integer, Text, ARRAY, TIMESTAMP
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column
from datetime import datetime
from ..database import Base
import uuid


class User(Base):
    __tablename__ = "users"
    __table_args__ = {"schema": "public"}

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True)
    display_name: Mapped[str] = mapped_column(String(100))
    handle: Mapped[str] = mapped_column(String(50), unique=True)
    bio: Mapped[str | None] = mapped_column(Text)
    avatar_url: Mapped[str | None] = mapped_column(Text)
    mood: Mapped[str | None] = mapped_column(String(200))
    prompt_count: Mapped[int] = mapped_column(Integer, default=0)
    echoes_received: Mapped[int] = mapped_column(Integer, default=0)
    collections_count: Mapped[int] = mapped_column(Integer, default=0)
    tuned_in_count: Mapped[int] = mapped_column(Integer, default=0)
    tuning_in_to_count: Mapped[int] = mapped_column(Integer, default=0)
    joined_at: Mapped[datetime] = mapped_column(TIMESTAMP(timezone=True))
    pinned_prompt_ids: Mapped[list] = mapped_column(ARRAY(UUID(as_uuid=True)), default=[])
