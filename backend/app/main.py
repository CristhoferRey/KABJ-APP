from fastapi import FastAPI

from app.routers.auth import router as auth_router
from app.routers.health import router as health_router
from app.routers.mobile import router as mobile_router

app = FastAPI(title="KABJ Backend", version="0.1.0")

app.include_router(health_router, tags=["health"])
app.include_router(auth_router, tags=["auth"])
app.include_router(mobile_router, tags=["mobile"])
