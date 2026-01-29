codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-drar0n
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ra2stf
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-70pu3t
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-fxsc7m
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-dvc5n3
 main
main
 main
 main
 main
 main
 main
 main
 main
main
from pathlib import Path

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
from app.routers.admin import router as admin_router
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
from app.routers.admin import router as admin_router
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
from app.routers.admin import router as admin_router
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
from app.routers.admin import router as admin_router
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
from app.routers.admin import router as admin_router
=======
 main
main
 main
 main
main
from app.routers.auth import router as auth_router
from app.routers.health import router as health_router
from app.routers.mobile import router as mobile_router

app = FastAPI(title="KABJ Backend", version="0.1.0")

uploads_dir = Path(__file__).resolve().parents[1] / "uploads"
uploads_dir.mkdir(parents=True, exist_ok=True)
app.mount("/uploads", StaticFiles(directory=uploads_dir), name="uploads")

app.include_router(health_router, tags=["health"])
app.include_router(auth_router, tags=["auth"])
app.include_router(mobile_router, tags=["mobile"])
codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
app.include_router(admin_router, tags=["admin"])
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
app.include_router(admin_router, tags=["admin"])
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
app.include_router(admin_router, tags=["admin"])
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
app.include_router(admin_router, tags=["admin"])
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
app.include_router(admin_router, tags=["admin"])
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-drar0n
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ra2stf
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-70pu3t
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-fxsc7m
=======
=======
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
main
main
main
main
main
 main
 main
 main
 main
 main
 main
