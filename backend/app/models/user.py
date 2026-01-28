codex/initialize-project-scaffolding-for-fastapi-and-flutter-ugb2w8
from sqlalchemy import Boolean, Column, Enum, Integer, String

from app.db.base import Base
from app.models.enums import UserRole
=======
from enum import Enum

from sqlalchemy import Column, Integer, String

from app.db.base import Base


class UserRole(str, Enum):
    admin = "ADMIN"
    capataz = "CAPATAZ"
main


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
codex/initialize-project-scaffolding-for-fastapi-and-flutter-ugb2w8
    name = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    password_hash = Column(String, nullable=False)
    role = Column(Enum(UserRole, name="user_role"), nullable=False, default=UserRole.capataz)
    is_active = Column(Boolean, default=True, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    role = Column(String, default=UserRole.capataz.value, nullable=False)
 main
