from enum import Enum

from sqlalchemy import Column, Integer, String

from app.db.base import Base


class UserRole(str, Enum):
    admin = "ADMIN"
    capataz = "CAPATAZ"


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    role = Column(String, default=UserRole.capataz.value, nullable=False)
