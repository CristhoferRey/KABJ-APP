from typing import Annotated

codex/initialize-project-scaffolding-for-fastapi-and-flutter-fxsc7m
from fastapi import Depends, Header, HTTPException, status
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-dvc5n3
from fastapi import Depends, Header, HTTPException, status
=======
from fastapi import Depends, HTTPException, status
 main
 main
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jose import JWTError, jwt
from sqlalchemy.orm import Session

from app.core.config import settings
from app.db.session import get_db
from app.models.user import User

security_scheme = HTTPBearer()


TokenCredentials = Annotated[HTTPAuthorizationCredentials, Depends(security_scheme)]


def get_current_user(
    credentials: TokenCredentials,
    db: Annotated[Session, Depends(get_db)],
) -> User:
    token = credentials.credentials
    try:
        payload = jwt.decode(token, settings.secret_key, algorithms=[settings.algorithm])
    except JWTError as exc:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid token") from exc

    subject = payload.get("sub")
    if not subject:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid token")

    user = db.query(User).filter(User.id == int(subject)).first()
    if not user or not user.is_active:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Inactive user")
    return user


def require_capataz(user: Annotated[User, Depends(get_current_user)]) -> User:
    if user.role != "CAPATAZ":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Forbidden")
    return user
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-fxsc7m
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-dvc5n3
 main


def get_device_id(x_device_id: Annotated[str | None, Header()] = None) -> str:
    if not x_device_id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Missing X-Device-Id header")
    return x_device_id
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-fxsc7m
=======
=======
main
 main
