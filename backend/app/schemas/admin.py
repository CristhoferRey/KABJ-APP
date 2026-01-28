from datetime import date
from typing import Any

from pydantic import BaseModel


class SectorBase(BaseModel):
    name: str
    district: str
    locality: str


class SectorCreate(SectorBase):
    pass


class SectorRead(SectorBase):
    id: int

    class Config:
        from_attributes = True


class SubActivityRead(BaseModel):
    id: int
    activity_id: int
    code: str
    name: str
    form_type: str

    class Config:
        from_attributes = True


class PointBase(BaseModel):
    subactivity_id: int
    sector_id: int
    sgio: str | None = None
    gis: str | None = None
    suministro: str | None = None
    direccion: str | None = None
    locality: str | None = None
    district: str | None = None
    lat: float
    lng: float


class PointCreate(PointBase):
    pass


class PointRead(PointBase):
    id: int
    is_active: bool

    class Config:
        from_attributes = True


class AssignmentCreate(BaseModel):
    subactivity_id: int
    sector_id: int
    capataz_id: int
    date_from: date
    date_to: date


class AssignmentRead(BaseModel):
    id: int
    subactivity_id: int
    sector_id: int
    capataz_id: int
    date_from: date
    date_to: date
    is_active: bool

    class Config:
        from_attributes = True


class ImportSummary(BaseModel):
    created: int
    skipped: int
    errors: list[str]


class ImportRowError(BaseModel):
    row: int
    message: str


class ImportSummaryDetailed(BaseModel):
    created: int
    skipped: int
    errors: list[ImportRowError]

    def to_summary(self) -> ImportSummary:
        return ImportSummary(
            created=self.created,
            skipped=self.skipped,
            errors=[f"row {err.row}: {err.message}" for err in self.errors],
        )
