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
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-dvc5n3
    is_closed: bool
    requires_evidence: bool = False
=======
 main

    class Config:
        from_attributes = True
