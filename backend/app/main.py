from fastapi import FastAPI

codex/initialize-project-scaffolding-for-fastapi-and-flutter-vry57d
from app.routers.auth import router as auth_router
from app.routers.health import router as health_router
from app.routers.mobile import router as mobile_router
=======
from app.routers.health import router as health_router
main

app = FastAPI(title="KABJ Backend", version="0.1.0")

app.include_router(health_router, tags=["health"])
codex/initialize-project-scaffolding-for-fastapi-and-flutter-vry57d
app.include_router(auth_router, tags=["auth"])
app.include_router(mobile_router, tags=["mobile"])
=======
main
