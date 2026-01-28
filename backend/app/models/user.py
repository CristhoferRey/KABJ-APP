codex/initialize-project-scaffolding-for-fastapi-and-flutter-dvc5n3
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-vry57d
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-ugb2w8
main
main
from sqlalchemy import Boolean, Column, Enum, Integer, String

from app.db.base import Base
from app.models.enums import UserRole
codex/initialize-project-scaffolding-for-fastapi-and-flutter-dvc5n3
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-vry57d
=======
=======
from enum import Enum

from sqlalchemy import Column, Integer, String

from app.db.base import Base


class UserRole(str, Enum):
    admin = "ADMIN"
    capataz = "CAPATAZ"
main
main
main


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
codex/initialize-project-scaffolding-for-fastapi-and-flutter-dvc5n3
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-vry57d
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-ugb2w8
main
 main
    name = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    password_hash = Column(String, nullable=False)
    role = Column(Enum(UserRole, name="user_role"), nullable=False, default=UserRole.capataz)
    is_active = Column(Boolean, default=True, nullable=False)
codex/initialize-project-scaffolding-for-fastapi-and-flutter-dvc5n3
    device_id = Column(String, nullable=True)
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-vry57d
=======
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    role = Column(String, default=UserRole.capataz.value, nullable=False)
 main
main
 main
