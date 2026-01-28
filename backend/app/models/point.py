from sqlalchemy import Boolean, Column, ForeignKey, Integer, String
from geoalchemy2 import Geometry

from app.db.base import Base


class Point(Base):
    __tablename__ = "points"

    id = Column(Integer, primary_key=True, index=True)
    subactivity_id = Column(Integer, ForeignKey("subactivities.id"), nullable=False, index=True)
    sector_id = Column(Integer, ForeignKey("sectors.id"), nullable=False, index=True)
    sgio = Column(String, nullable=True)
    gis = Column(String, nullable=True)
    suministro = Column(String, nullable=True)
    direccion = Column(String, nullable=True)
    locality = Column(String, nullable=True)
    district = Column(String, nullable=True)
    geom = Column(Geometry(geometry_type="POINT", srid=4326), nullable=False)
    is_active = Column(Boolean, default=True, nullable=False)
