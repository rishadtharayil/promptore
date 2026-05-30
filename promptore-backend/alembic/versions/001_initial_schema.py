"""Initial schema

Revision ID: 001
Revises:
Create Date: 2024-01-01 00:00:00.000000
"""
from typing import Sequence, Union
from alembic import op

revision: str = "001"
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.execute('CREATE EXTENSION IF NOT EXISTS "pgcrypto";')

    # ──────────────────── USERS ────────────────────
    op.execute("""
    CREATE TABLE IF NOT EXISTS public.users (
        id                  UUID        PRIMARY KEY,
        display_name        VARCHAR(100) NOT NULL,
        handle              VARCHAR(50)  UNIQUE NOT NULL,
        bio                 TEXT,
        avatar_url          TEXT,
        mood                VARCHAR(200),
        prompt_count        INTEGER      NOT NULL DEFAULT 0,
        echoes_received     INTEGER      NOT NULL DEFAULT 0,
        collections_count   INTEGER      NOT NULL DEFAULT 0,
        tuned_in_count      INTEGER      NOT NULL DEFAULT 0,
        tuning_in_to_count  INTEGER      NOT NULL DEFAULT 0,
        joined_at           TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
        pinned_prompt_ids   UUID[]       NOT NULL DEFAULT ARRAY[]::UUID[]
    );
    """)

    # ──────────────────── PROMPTS ────────────────────
    op.execute("""
    CREATE TABLE IF NOT EXISTS public.prompts (
        id                UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
        title             VARCHAR(300) NOT NULL,
        excerpt           TEXT        NOT NULL,
        content           TEXT        NOT NULL,
        author_id         UUID        NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
        category          VARCHAR(50)  NOT NULL,
        tags              TEXT[]       NOT NULL DEFAULT ARRAY[]::TEXT[],
        echo_count        INTEGER      NOT NULL DEFAULT 0,
        archive_count     INTEGER      NOT NULL DEFAULT 0,
        remix_count       INTEGER      NOT NULL DEFAULT 0,
        annotation_count  INTEGER      NOT NULL DEFAULT 0,
        remix_of_id       UUID         REFERENCES public.prompts(id) ON DELETE SET NULL,
        remix_of_title    VARCHAR(300),
        thumbnail_url     TEXT,
        size              VARCHAR(20)  NOT NULL DEFAULT 'medium',
        impact_score      FLOAT        NOT NULL DEFAULT 0.0,
        search_vector     TSVECTOR,
        created_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
        updated_at        TIMESTAMPTZ
    );
    """)

    # ──────────────────── ECHOES ────────────────────
    op.execute("""
    CREATE TABLE IF NOT EXISTS public.echoes (
        user_id     UUID        NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
        prompt_id   UUID        NOT NULL REFERENCES public.prompts(id) ON DELETE CASCADE,
        created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        PRIMARY KEY (user_id, prompt_id)
    );
    """)

    # ──────────────────── ARCHIVES ────────────────────
    op.execute("""
    CREATE TABLE IF NOT EXISTS public.archives (
        user_id     UUID        NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
        prompt_id   UUID        NOT NULL REFERENCES public.prompts(id) ON DELETE CASCADE,
        created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        PRIMARY KEY (user_id, prompt_id)
    );
    """)

    # ──────────────────── FOLLOWS ────────────────────
    op.execute("""
    CREATE TABLE IF NOT EXISTS public.follows (
        follower_id  UUID        NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
        following_id UUID        NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
        created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        PRIMARY KEY (follower_id, following_id),
        CONSTRAINT no_self_follow CHECK (follower_id != following_id)
    );
    """)

    # ──────────────────── COLLECTIONS ────────────────────
    op.execute("""
    CREATE TABLE IF NOT EXISTS public.collections (
        id            UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
        name          VARCHAR(200) NOT NULL,
        description   TEXT,
        owner_id      UUID         NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
        prompt_count  INTEGER      NOT NULL DEFAULT 0,
        cover_color   VARCHAR(20)  DEFAULT '#5A6B8B',
        is_public     BOOLEAN      NOT NULL DEFAULT TRUE,
        created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW()
    );
    """)

    # ──────────────────── COLLECTION_PROMPTS ────────────────────
    op.execute("""
    CREATE TABLE IF NOT EXISTS public.collection_prompts (
        collection_id UUID        NOT NULL REFERENCES public.collections(id) ON DELETE CASCADE,
        prompt_id     UUID        NOT NULL REFERENCES public.prompts(id) ON DELETE CASCADE,
        added_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        PRIMARY KEY (collection_id, prompt_id)
    );
    """)

    # ──────────────────── ANNOTATIONS ────────────────────
    op.execute("""
    CREATE TABLE IF NOT EXISTS public.annotations (
        id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
        prompt_id   UUID        NOT NULL REFERENCES public.prompts(id) ON DELETE CASCADE,
        author_id   UUID        NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
        content     TEXT        NOT NULL,
        created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
    """)

    # ──────────────────── INDEXES ────────────────────
    op.execute("CREATE INDEX IF NOT EXISTS idx_prompts_author     ON public.prompts(author_id);")
    op.execute("CREATE INDEX IF NOT EXISTS idx_prompts_category   ON public.prompts(category);")
    op.execute("CREATE INDEX IF NOT EXISTS idx_prompts_impact     ON public.prompts(impact_score DESC);")
    op.execute("CREATE INDEX IF NOT EXISTS idx_prompts_created    ON public.prompts(created_at DESC);")
    op.execute("CREATE INDEX IF NOT EXISTS idx_prompts_tags       ON public.prompts USING GIN(tags);")
    op.execute("CREATE INDEX IF NOT EXISTS idx_prompts_search     ON public.prompts USING GIN(search_vector);")
    op.execute("CREATE INDEX IF NOT EXISTS idx_echoes_prompt      ON public.echoes(prompt_id);")
    op.execute("CREATE INDEX IF NOT EXISTS idx_archives_user      ON public.archives(user_id);")
    op.execute("CREATE INDEX IF NOT EXISTS idx_follows_follower   ON public.follows(follower_id);")
    op.execute("CREATE INDEX IF NOT EXISTS idx_follows_following  ON public.follows(following_id);")
    op.execute("CREATE INDEX IF NOT EXISTS idx_annotations_prompt ON public.annotations(prompt_id);")
    op.execute("CREATE INDEX IF NOT EXISTS idx_collprompts_coll   ON public.collection_prompts(collection_id);")

    # ──────────────────── FULL-TEXT SEARCH TRIGGER ────────────────────
    op.execute("""
    CREATE OR REPLACE FUNCTION update_prompts_search_vector()
    RETURNS TRIGGER AS $$
    BEGIN
        NEW.search_vector = to_tsvector('english',
            COALESCE(NEW.title, '') || ' ' ||
            COALESCE(NEW.excerpt, '') || ' ' ||
            COALESCE(array_to_string(NEW.tags, ' '), '')
        );
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
    """)

    op.execute("DROP TRIGGER IF EXISTS prompts_search_trigger ON public.prompts;")
    op.execute("""
    CREATE TRIGGER prompts_search_trigger
        BEFORE INSERT OR UPDATE ON public.prompts
        FOR EACH ROW EXECUTE FUNCTION update_prompts_search_vector();
    """)

    # ──────────────────── AUTO-CREATE USER ON SIGNUP ────────────────────
    op.execute("""
    CREATE OR REPLACE FUNCTION public.handle_new_auth_user()
    RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO public.users (id, display_name, handle, joined_at)
        VALUES (
            NEW.id,
            COALESCE(NEW.raw_user_meta_data->>'display_name', split_part(NEW.email, '@', 1)),
            'user_' || substr(replace(NEW.id::text, '-', ''), 1, 8),
            NOW()
        )
        ON CONFLICT (id) DO NOTHING;
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql SECURITY DEFINER;
    """)

    op.execute("DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;")
    op.execute("""
    CREATE TRIGGER on_auth_user_created
        AFTER INSERT ON auth.users
        FOR EACH ROW EXECUTE FUNCTION public.handle_new_auth_user();
    """)


def downgrade() -> None:
    op.execute("DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;")
    op.execute("DROP FUNCTION IF EXISTS public.handle_new_auth_user();")
    op.execute("DROP TRIGGER IF EXISTS prompts_search_trigger ON public.prompts;")
    op.execute("DROP FUNCTION IF EXISTS update_prompts_search_vector();")
    op.execute("DROP TABLE IF EXISTS public.collection_prompts CASCADE;")
    op.execute("DROP TABLE IF EXISTS public.annotations CASCADE;")
    op.execute("DROP TABLE IF EXISTS public.collections CASCADE;")
    op.execute("DROP TABLE IF EXISTS public.follows CASCADE;")
    op.execute("DROP TABLE IF EXISTS public.archives CASCADE;")
    op.execute("DROP TABLE IF EXISTS public.echoes CASCADE;")
    op.execute("DROP TABLE IF EXISTS public.prompts CASCADE;")
    op.execute("DROP TABLE IF EXISTS public.users CASCADE;")
