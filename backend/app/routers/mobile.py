from datetime import date

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import and_, func
from sqlalchemy.orm import Session

from app.core.deps import require_capataz
from app.db.session import get_db
from app.models.assignment import Assignment
from app.models.enums import ExecutionStatus
from app.models.execution import Execution
from app.models.point import Point
from app.models.user import User
from app.schemas.execution import ExecutionCreate, ExecutionResponse
from app.schemas.point import PointResponse
from app.schemas.summary import SummaryResponse

router = APIRouter(prefix="/mobile")


@router.get("/points", response_model=list[PointResponse])
def list_points(
    sector_id: int,
    subactivity_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_capataz),
) -> list[PointResponse]:
    latest_exec_sub = (
        db.query(
            Execution.point_id.label("point_id"),
            func.max(Execution.created_at).label("max_created_at"),
        )
        .group_by(Execution.point_id)
        .subquery()
    )

    latest_exec = (
        db.query(Execution)
        .join(
            latest_exec_sub,
            and_(
                Execution.point_id == latest_exec_sub.c.point_id,
                Execution.created_at == latest_exec_sub.c.max_created_at,
            ),
        )
        .subquery()
    )

    assignment_exists = (
        db.query(Assignment.id)
        .filter(
            Assignment.capataz_id == current_user.id,
            Assignment.sector_id == sector_id,
            Assignment.subactivity_id == subactivity_id,
            Assignment.is_active.is_(True),
        )
        .exists()
    )

    query = (
        db.query(
            Point,
            func.ST_Y(Point.geom).label("lat"),
            func.ST_X(Point.geom).label("lng"),
            latest_exec.c.status.label("latest_status"),
        )
        .filter(
            Point.sector_id == sector_id,
            Point.subactivity_id == subactivity_id,
            Point.is_active.is_(True),
            assignment_exists,
        )
        .outerjoin(latest_exec, Point.id == latest_exec.c.point_id)
    )

    rows = query.all()
    results: list[PointResponse] = []
    for point, lat, lng, latest_status in rows:
        if latest_status in {ExecutionStatus.resuelto, ExecutionStatus.imposibilidad}:
            continue
        if latest_status is not None and latest_status != ExecutionStatus.pendiente:
            continue
        results.append(
            PointResponse(
                id=point.id,
                subactivity_id=point.subactivity_id,
                sector_id=point.sector_id,
                sgio=point.sgio,
                gis=point.gis,
                suministro=point.suministro,
                direccion=point.direccion,
                locality=point.locality,
                district=point.district,
                is_active=point.is_active,
                lat=lat,
                lng=lng,
            )
        )

    return results


@router.post("/executions", response_model=ExecutionResponse, status_code=status.HTTP_201_CREATED)
def create_execution(
    payload: ExecutionCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_capataz),
) -> ExecutionResponse:
    if payload.status not in {
        ExecutionStatus.resuelto,
        ExecutionStatus.imposibilidad,
        ExecutionStatus.reprogramacion,
    }:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid status")

    point = db.query(Point).filter(Point.id == payload.point_id).first()
    if not point:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Point not found")

    assignment = (
        db.query(Assignment)
        .filter(
            Assignment.capataz_id == current_user.id,
            Assignment.sector_id == point.sector_id,
            Assignment.subactivity_id == point.subactivity_id,
            Assignment.is_active.is_(True),
        )
        .first()
    )
    if not assignment:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Point not assigned")

    duration_minutes = None
    if payload.started_at and payload.ended_at:
        duration = payload.ended_at - payload.started_at
        duration_minutes = int(duration.total_seconds() // 60)

    execution = Execution(
        point_id=payload.point_id,
        capataz_id=current_user.id,
        assignment_id=payload.assignment_id or assignment.id,
        status=payload.status,
        started_at=payload.started_at,
        ended_at=payload.ended_at,
        duration_minutes=duration_minutes,
        form_data=payload.form_data,
    )
    db.add(execution)
    db.commit()
    db.refresh(execution)
    return ExecutionResponse.model_validate(execution)


@router.get("/summary", response_model=SummaryResponse)
def get_summary(
    db: Session = Depends(get_db),
    current_user: User = Depends(require_capataz),
) -> SummaryResponse:
    today = date.today()

    executed_today = (
        db.query(Execution)
        .filter(
            Execution.capataz_id == current_user.id,
            func.date(Execution.created_at) == today,
        )
        .count()
    )

    latest_exec_sub = (
        db.query(
            Execution.point_id.label("point_id"),
            func.max(Execution.created_at).label("max_created_at"),
        )
        .group_by(Execution.point_id)
        .subquery()
    )

    latest_exec = (
        db.query(Execution)
        .join(
            latest_exec_sub,
            and_(
                Execution.point_id == latest_exec_sub.c.point_id,
                Execution.created_at == latest_exec_sub.c.max_created_at,
            ),
        )
        .subquery()
    )

    pending_today_query = (
        db.query(Point.id, latest_exec.c.status.label("latest_status"))
        .join(
            Assignment,
            and_(
                Assignment.capataz_id == current_user.id,
                Assignment.sector_id == Point.sector_id,
                Assignment.subactivity_id == Point.subactivity_id,
                Assignment.is_active.is_(True),
            ),
        )
        .outerjoin(latest_exec, Point.id == latest_exec.c.point_id)
        .filter(Point.is_active.is_(True))
    )

    pending_today = 0
    for _, latest_status in pending_today_query.all():
        if latest_status in {ExecutionStatus.resuelto, ExecutionStatus.imposibilidad}:
            continue
        if latest_status is not None and latest_status != ExecutionStatus.pendiente:
            continue
        pending_today += 1

    return SummaryResponse(executed_today=executed_today, pending_today=pending_today)
