from sqlalchemy import Boolean, Column, Date, ForeignKey, Integer

from app.db.base import Base


class Assignment(Base):
    __tablename__ = "assignments"

    id = Column(Integer, primary_key=True, index=True)
    subactivity_id = Column(Integer, ForeignKey("subactivities.id"), nullable=False, index=True)
    sector_id = Column(Integer, ForeignKey("sectors.id"), nullable=False, index=True)
    capataz_id = Column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    date_from = Column(Date, nullable=False)
    date_to = Column(Date, nullable=False)
    is_active = Column(Boolean, default=True, nullable=False)
