from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .config import settings
from .routers import prompts, users, collections, annotations, search, explore

app = FastAPI(title="Promptore API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(prompts.router, prefix="/api/v1/prompts", tags=["prompts"])
app.include_router(users.router, prefix="/api/v1/users", tags=["users"])
app.include_router(collections.router, prefix="/api/v1/collections", tags=["collections"])
app.include_router(annotations.router, prefix="/api/v1", tags=["annotations"])
app.include_router(search.router, prefix="/api/v1/search", tags=["search"])
app.include_router(explore.router, prefix="/api/v1/explore", tags=["explore"])


@app.get("/health")
async def health():
    return {"status": "ok"}
