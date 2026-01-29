from sqlalchemy import Column, Integer, String

from app.db.base import Base


class Sector(Base):
    __tablename__ = "sectors"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    district = Column(String, nullable=False)
    locality = Column(String, nullable=False)
