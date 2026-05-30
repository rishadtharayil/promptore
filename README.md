# 🌌 Promptore

> **A living archive of human imagination** — *discover, collect, and remix powerful AI prompts.*

Promptore is a premium, atmospheric prompt-sharing platform designed for writers, coders, worldbuilders, and dreamers. Styled with rich dark hues, subtle neon glows, and vintage light-parchment modes — transforming prompt discovery into an experience of uncovering forgotten transmissions, forbidden archives, and machine dreams.

---

## 🏛️ Architecture

```
promptore/
├── lib/                    # Flutter mobile app
├── promptore_web/          # React + Vite web app
└── promptore-backend/      # FastAPI backend (Python)
```

---

## 🚀 Quick Start

### 1. Backend (FastAPI + Supabase)

```bash
cd promptore-backend

# Install dependencies
pip install -r requirements.txt

# Configure environment
cp .env.example .env
# Edit .env with your Supabase credentials:
#   DATABASE_URL, SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_JWT_SECRET

# Run database migrations
alembic upgrade head

# Start the server
uvicorn app.main:app --reload
```

API docs available at [http://localhost:8000/docs](http://localhost:8000/docs)

### 2. Mobile App (Flutter)

```bash
flutter pub get
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key \
  --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

### 3. Web App (React + Vite)

```bash
cd promptore_web
npm install
npm run dev
```

Open 👉 [http://localhost:5173](http://localhost:5173)

---

## 🔌 Backend API

**Base URL:** `/api/v1`

| Resource | Endpoints | Auth |
|----------|-----------|------|
| **Prompts** | `GET /prompts/feed`, `GET /prompts/trending`, `GET/POST /prompts`, `PUT/DELETE /prompts/:id`, `GET /prompts/:id/remixes` | ✅ |
| **Interactions** | `POST/DELETE /prompts/:id/echo`, `POST/DELETE /prompts/:id/archive` | ✅ |
| **Users** | `GET/PUT /users/me`, `GET /users/:id`, `GET /users/:id/prompts`, `POST/DELETE /users/:id/follow` | ✅ |
| **Collections** | `GET/POST /collections`, `DELETE /collections/:id`, `POST/DELETE /collections/:id/prompts/:pid` | ✅ |
| **Annotations** | `GET/POST /prompts/:id/annotations` | ✅ |
| **Search** | `GET /search?q=...&category=...&tags=...` | ❌ |
| **Explore** | `GET /explore/categories`, `GET /explore/trending-tags` | ❌ |
| **Health** | `GET /health` | ❌ |

All authenticated endpoints use Supabase JWT (Bearer token).

---

## ✨ Features

### 📡 Telemetry Feed
- **Personalized Feed** — 60% from creators you follow, 40% discovery, interleaved and cursor-paginated
- **Impact Scoring** — Decay-weighted ranking: `(echoes×3 + archives×2 + remixes×5 + annotations) / age^1.5`
- **Echoes & Archives** — Like and save prompts with optimistic UI updates
- **Remixes** — Fork any prompt and build on it, with attribution

### 🏛️ Collections & Curation
- **Custom Archives** — Organize prompts into themed collections
- **Public/Private** — Control visibility of your collections
- **Collection Volumes** — Beautifully designed detail drawers

### 🔍 Search & Discovery
- **Full-text Search** — PostgreSQL `tsvector` powered search across titles, excerpts, and content
- **Category Browsing** — 13 curated categories with visual identity
- **Trending Tags** — Discover what the community is exploring

### 👤 Profiles & Social
- **Creator Profiles** — Display name, handle, bio, mood, pinned prompts
- **Tune In** — Follow creators to populate your feed
- **Annotations** — Leave margin notes and thoughts on prompts

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| **Mobile** | Flutter 3.12+, Riverpod, GoRouter, Hive |
| **Web** | React, Vite 8.0, CSS custom properties |
| **Backend** | FastAPI, SQLAlchemy (async), Alembic, Pydantic |
| **Database** | Supabase (PostgreSQL), pgcrypto, tsvector FTS |
| **Auth** | Supabase Auth, JWT (HS256) |
| **API Client** | Dio with auth interceptor |

---

## 🎨 Design

- **Dark Mode (Obsidian)** — Deep atmospheric tones with neon accents
- **Light Mode (Parchment)** — Warm vintage aesthetics
- **Micro-animations** — Smooth transitions via `flutter_animate`
- **Web A11y** — Semantic HTML, focus-visible outlines, ARIA labels, keyboard navigation

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── config/          # App configuration (Supabase URLs, API base)
│   ├── models/          # Domain models with fromJson/toJson
│   ├── providers/       # Riverpod state management
│   ├── repositories/    # API data layer (Dio → backend)
│   ├── router/          # GoRouter navigation
│   ├── services/        # API client (Dio singleton)
│   ├── theme/           # Colors, typography, theme data
│   └── widgets/         # Reusable UI components
├── features/            # Feature screens (feed, profile, explore, etc.)
├── shell/               # Main navigation shell
└── main.dart            # App entry point + Supabase init

promptore-backend/
├── app/
│   ├── models/          # SQLAlchemy ORM models
│   ├── schemas/         # Pydantic request/response schemas
│   ├── routers/         # FastAPI route handlers
│   ├── services/        # Business logic (feed, impact score)
│   ├── config.py        # Environment settings
│   ├── database.py      # Async engine + session
│   ├── dependencies.py  # JWT auth middleware
│   └── main.py          # FastAPI app entry point
├── alembic/             # Database migrations
├── requirements.txt
└── .env.example
```

---

## 📜 License

This project is proprietary. All rights reserved.
