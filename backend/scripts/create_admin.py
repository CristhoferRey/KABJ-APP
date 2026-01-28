import os

from app.core.security import hash_password
from app.db.session import SessionLocal
from app.models.enums import UserRole
from app.models.user import User


def main() -> None:
    name = os.getenv("KABJ_ADMIN_NAME", "Admin")
    email = os.getenv("KABJ_ADMIN_EMAIL")
    password = os.getenv("KABJ_ADMIN_PASSWORD")

    if not email or not password:
        raise SystemExit("KABJ_ADMIN_EMAIL and KABJ_ADMIN_PASSWORD are required")

    db = SessionLocal()
    try:
        existing = db.query(User).filter(User.email == email).first()
        if existing:
            raise SystemExit("Admin user already exists")

        user = User(
            name=name,
            email=email,
            password_hash=hash_password(password),
            role=UserRole.admin.value,
            is_active=True,
        )
        db.add(user)
        db.commit()
    finally:
        db.close()


if __name__ == "__main__":
    main()
