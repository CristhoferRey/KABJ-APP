from fastapi import FastAPI

from app.routers.health import router as health_router

app = FastAPI(title="KABJ Backend", version="0.1.0")

app.include_router(health_router, tags=["health"])
