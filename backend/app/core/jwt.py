from datetime import datetime, timedelta, timezone
from typing import Any

from jose import jwt

from app.core.config import settings


codex/initialize-project-scaffolding-for-fastapi-and-flutter-dvc5n3
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-vry57d
 main
def create_access_token(
    subject: str,
    role: str,
    expires_delta: timedelta | None = None,
) -> str:
    expire = datetime.now(timezone.utc) + (
        expires_delta or timedelta(minutes=settings.access_token_expire_minutes)
    )
    to_encode: dict[str, Any] = {"sub": subject, "role": role, "exp": expire}
codex/initialize-project-scaffolding-for-fastapi-and-flutter-dvc5n3
=======
=======
def create_access_token(subject: str, expires_delta: timedelta | None = None) -> str:
    expire = datetime.now(timezone.utc) + (
        expires_delta or timedelta(minutes=settings.access_token_expire_minutes)
    )
    to_encode: dict[str, Any] = {"sub": subject, "exp": expire}
main
main
    return jwt.encode(to_encode, settings.secret_key, algorithm=settings.algorithm)
