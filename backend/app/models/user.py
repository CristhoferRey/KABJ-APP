from sqlalchemy import Boolean, Column, Enum, Integer, String

from app.db.base import Base
from app.models.enums import UserRole


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    password_hash = Column(String, nullable=False)
    role = Column(Enum(UserRole, name="user_role"), nullable=False, default=UserRole.capataz)
    is_active = Column(Boolean, default=True, nullable=False)
    device_id = Column(String, nullable=True)
