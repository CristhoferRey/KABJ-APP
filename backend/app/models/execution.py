 codex/initialize-project-scaffolding-for-fastapi-and-flutter-70pu3t
from sqlalchemy import Boolean, Column, DateTime, Enum, ForeignKey, Integer
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-fxsc7m
from sqlalchemy import Boolean, Column, DateTime, Enum, ForeignKey, Integer
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-dvc5n3
from sqlalchemy import Boolean, Column, DateTime, Enum, ForeignKey, Integer
=======
from sqlalchemy import Column, DateTime, Enum, ForeignKey, Integer
 main
 main
 main
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.sql import func

from app.db.base import Base
from app.models.enums import ExecutionStatus


class Execution(Base):
    __tablename__ = "executions"

    id = Column(Integer, primary_key=True, index=True)
    point_id = Column(Integer, ForeignKey("points.id"), nullable=False, index=True)
    capataz_id = Column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    assignment_id = Column(Integer, ForeignKey("assignments.id"), nullable=True, index=True)
    status = Column(Enum(ExecutionStatus, name="execution_status"), nullable=False)
    started_at = Column(DateTime(timezone=True), nullable=True)
    ended_at = Column(DateTime(timezone=True), nullable=True)
    duration_minutes = Column(Integer, nullable=True)
    form_data = Column(JSONB, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
codex/initialize-project-scaffolding-for-fastapi-and-flutter-70pu3t
    is_closed = Column(Boolean, default=False, nullable=False)
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-fxsc7m
    is_closed = Column(Boolean, default=False, nullable=False)
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-dvc5n3
    is_closed = Column(Boolean, default=False, nullable=False)
=======
 main
 main
main
