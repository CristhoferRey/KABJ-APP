from datetime import datetime
from pydantic import BaseModel

from app.models.enums import ExecutionStatus


class ExecutionCreate(BaseModel):
    point_id: int
    status: ExecutionStatus
    started_at: datetime | None = None
    ended_at: datetime | None = None
    form_data: dict | None = None
    assignment_id: int | None = None


class ExecutionResponse(BaseModel):
    id: int
    point_id: int
    status: ExecutionStatus
    created_at: datetime
    duration_minutes: int | None = None

    class Config:
        from_attributes = True
