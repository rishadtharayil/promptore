from sqlalchemy import String, Integer, Text, Float, ARRAY, TIMESTAMP, ForeignKey
from sqlalchemy.dialects.postgresql import UUID, TSVECTOR
from sqlalchemy.orm import Mapped, mapped_column
from datetime import datetime
from ..database import Base
import uuid


class Prompt(Base):
    __tablename__ = "prompts"
    __table_args__ = {"schema": "public"}

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    title: Mapped[str] = mapped_column(String(300))
    excerpt: Mapped[str] = mapped_column(Text)
    content: Mapped[str] = mapped_column(Text)
    author_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("public.users.id"))
    category: Mapped[str] = mapped_column(String(50))
    tags: Mapped[list] = mapped_column(ARRAY(Text), default=[])
    echo_count: Mapped[int] = mapped_column(Integer, default=0)
    archive_count: Mapped[int] = mapped_column(Integer, default=0)
    remix_count: Mapped[int] = mapped_column(Integer, default=0)
    annotation_count: Mapped[int] = mapped_column(Integer, default=0)
    remix_of_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("public.prompts.id"), nullable=True)
    remix_of_title: Mapped[str | None] = mapped_column(String(300))
    thumbnail_url: Mapped[str | None] = mapped_column(Text)
    size: Mapped[str] = mapped_column(String(20), default="medium")
    impact_score: Mapped[float] = mapped_column(Float, default=0.0)
    search_vector: Mapped[str | None] = mapped_column(TSVECTOR)
    created_at: Mapped[datetime] = mapped_column(TIMESTAMP(timezone=True))
    updated_at: Mapped[datetime | None] = mapped_column(TIMESTAMP(timezone=True))
