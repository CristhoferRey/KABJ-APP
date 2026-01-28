from datetime import date, datetime
from pathlib import Path
from uuid import uuid4

from fastapi import APIRouter, Depends, File, HTTPException, UploadFile, status
from sqlalchemy import and_, func
from sqlalchemy.orm import Session

from app.core.deps import get_device_id, require_capataz
from app.db.session import get_db
from app.models.assignment import Assignment
from app.models.enums import ExecutionStatus
from app.models.evidence import Evidence
from app.models.execution import Execution
from app.models.point import Point
from app.models.user import User
from app.schemas.evidence import EvidenceResponse
from app.schemas.execution import ExecutionCreate, ExecutionResponse
from app.schemas.point import PointResponse
from app.schemas.summary import SummaryResponse

router = APIRouter(prefix="/mobile")

UPLOAD_DIR = Path(__file__).resolve().parents[2] / "uploads"
MAX_UPLOAD_BYTES = 8 * 1024 * 1024
ALLOWED_CONTENT_TYPES = {"image/jpeg", "image/png"}


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
        db.query(
            Execution.point_id.label("point_id"),
            Execution.status.label("status"),
            Execution.is_closed.label("is_closed"),
            Execution.created_at.label("created_at"),
        )
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
            latest_exec.c.is_closed.label("latest_is_closed"),
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
    for point, lat, lng, latest_status, latest_is_closed in rows:
        needs_evidence = False
        if latest_status == ExecutionStatus.resuelto and latest_is_closed is False:
            needs_evidence = True
        if latest_status in {ExecutionStatus.resuelto, ExecutionStatus.imposibilidad} and latest_is_closed:
            continue
        if latest_status is not None and latest_status != ExecutionStatus.pendiente and not needs_evidence:
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
                needs_evidence=needs_evidence,
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

    is_closed = payload.status in {ExecutionStatus.imposibilidad, ExecutionStatus.reprogramacion}
    execution = Execution(
        point_id=payload.point_id,
        capataz_id=current_user.id,
        assignment_id=payload.assignment_id or assignment.id,
        status=payload.status,
        started_at=payload.started_at,
        ended_at=payload.ended_at,
        duration_minutes=duration_minutes,
        form_data=payload.form_data,
        is_closed=is_closed,
    )
    db.add(execution)
    db.commit()
    db.refresh(execution)
    response = ExecutionResponse.model_validate(execution)
    response.requires_evidence = execution.status == ExecutionStatus.resuelto and not execution.is_closed
    return response


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
        db.query(
            Execution.point_id.label("point_id"),
            Execution.status.label("status"),
            Execution.is_closed.label("is_closed"),
            Execution.created_at.label("created_at"),
        )
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
        db.query(
            Point.id,
            latest_exec.c.status.label("latest_status"),
            latest_exec.c.is_closed.label("latest_is_closed"),
        )
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
    for _, latest_status, latest_is_closed in pending_today_query.all():
        needs_evidence = latest_status == ExecutionStatus.resuelto and latest_is_closed is False
        if latest_status in {ExecutionStatus.resuelto, ExecutionStatus.imposibilidad} and latest_is_closed:
            continue
        if latest_status is not None and latest_status != ExecutionStatus.pendiente and not needs_evidence:
            continue
        pending_today += 1

    return SummaryResponse(executed_today=executed_today, pending_today=pending_today)


@router.post("/evidence", response_model=EvidenceResponse, status_code=status.HTTP_201_CREATED)
def upload_evidence(
    execution_id: int,
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: User = Depends(require_capataz),
    device_id: str = Depends(get_device_id),
) -> EvidenceResponse:
    if file.content_type not in ALLOWED_CONTENT_TYPES:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid content type")

    execution = db.query(Execution).filter(Execution.id == execution_id).first()
    if not execution:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Execution not found")
    if execution.capataz_id != current_user.id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Forbidden")
    if execution.status == ExecutionStatus.reprogramacion:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Evidence not allowed")
    if execution.status == ExecutionStatus.pendiente:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid execution status")

    if current_user.device_id is None:
        current_user.device_id = device_id
        db.add(current_user)
        db.commit()
        db.refresh(current_user)
    elif current_user.device_id != device_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Device mismatch")

    file_data = file.file.read()
    if len(file_data) > MAX_UPLOAD_BYTES:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="File too large")

    UPLOAD_DIR.mkdir(parents=True, exist_ok=True)
    extension = ".jpg" if file.content_type == "image/jpeg" else ".png"
    filename = f"{execution.id}_{int(datetime.utcnow().timestamp())}_{uuid4().hex}{extension}"
    file_path = UPLOAD_DIR / filename
    file_path.write_bytes(file_data)

    evidence = Evidence(
        execution_id=execution.id,
        file_url=f"/uploads/{filename}",
        device_id=device_id,
    )
    db.add(evidence)

    if execution.status == ExecutionStatus.resuelto:
        execution.is_closed = True
        db.add(execution)

    db.commit()
    db.refresh(evidence)
    return EvidenceResponse.model_validate(evidence)
