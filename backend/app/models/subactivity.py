from sqlalchemy import Column, Enum, ForeignKey, Integer, String

from app.db.base import Base
from app.models.enums import FormType


class SubActivity(Base):
    __tablename__ = "subactivities"

    id = Column(Integer, primary_key=True, index=True)
    activity_id = Column(Integer, ForeignKey("activities.id"), nullable=False, index=True)
    code = Column(String, nullable=False)
    name = Column(String, nullable=False)
    form_type = Column(Enum(FormType, name="form_type"), nullable=False)
