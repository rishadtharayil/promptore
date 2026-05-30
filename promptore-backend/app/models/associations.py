from sqlalchemy import Table, Column, ForeignKey, TIMESTAMP
from sqlalchemy.dialects.postgresql import UUID
from ..database import Base

echoes = Table(
    "echoes",
    Base.metadata,
    Column("user_id", UUID(as_uuid=True), ForeignKey("public.users.id"), primary_key=True),
    Column("prompt_id", UUID(as_uuid=True), ForeignKey("public.prompts.id"), primary_key=True),
    Column("created_at", TIMESTAMP(timezone=True)),
    schema="public",
)

archives = Table(
    "archives",
    Base.metadata,
    Column("user_id", UUID(as_uuid=True), ForeignKey("public.users.id"), primary_key=True),
    Column("prompt_id", UUID(as_uuid=True), ForeignKey("public.prompts.id"), primary_key=True),
    Column("created_at", TIMESTAMP(timezone=True)),
    schema="public",
)

follows = Table(
    "follows",
    Base.metadata,
    Column("follower_id", UUID(as_uuid=True), ForeignKey("public.users.id"), primary_key=True),
    Column("following_id", UUID(as_uuid=True), ForeignKey("public.users.id"), primary_key=True),
    Column("created_at", TIMESTAMP(timezone=True)),
    schema="public",
)
