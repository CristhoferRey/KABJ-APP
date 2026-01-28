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
codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
    is_closed: bool
    requires_evidence: bool = False
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-drar0n
    is_closed: bool
    requires_evidence: bool = False
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ra2stf
    is_closed: bool
    requires_evidence: bool = False
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-70pu3t
    is_closed: bool
    requires_evidence: bool = False
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-fxsc7m
    is_closed: bool
    requires_evidence: bool = False
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-dvc5n3
    is_closed: bool
    requires_evidence: bool = False
=======
main
main
main
main
main
main

    class Config:
        from_attributes = True
