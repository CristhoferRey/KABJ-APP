from datetime import date as date_type
from pathlib import Path
from zipfile import ZipFile

from fastapi import APIRouter, Depends, HTTPException, Query, Response, status
from fastapi.responses import FileResponse
from sqlalchemy import and_, func
from sqlalchemy.orm import Session

from app.core.config import settings
from app.core.deps import require_admin
from app.db.session import get_db
from app.models.evidence import Evidence
from app.models.execution import Execution
from app.models.point import Point
from app.models.sector import Sector
from app.models.subactivity import SubActivity
from app.models.user import User
from app.services.export_service import (
    build_headers,
    build_rows,
    ensure_export_dir,
    group_by_subactivity,
    write_workbook,
)

router = APIRouter(prefix="/admin")


@router.post("/export")
def export_daily(
    export_date: date_type = Query(..., alias="date"),
    db: Session = Depends(get_db),
    _: str = Depends(require_admin),
):
    evidence_sub = (
        db.query(
            Evidence.execution_id.label("execution_id"),
            func.max(Evidence.created_at).label("max_created_at"),
        )
        .group_by(Evidence.execution_id)
        .subquery()
    )

    evidence_latest = (
        db.query(Evidence)
        .join(
            evidence_sub,
            and_(
                Evidence.execution_id == evidence_sub.c.execution_id,
                Evidence.created_at == evidence_sub.c.max_created_at,
            ),
        )
        .subquery()
    )

    executions = (
        db.query(
            Execution,
            User.name.label("capataz_name"),
            User.email.label("capataz_email"),
            Sector.name.label("sector_name"),
            Sector.district.label("district"),
            Sector.locality.label("locality"),
            Point.sgio.label("sgio"),
            Point.gis.label("gis"),
            Point.suministro.label("suministro"),
            Point.direccion.label("direccion"),
            SubActivity.code.label("subactivity_code"),
            SubActivity.name.label("subactivity_name"),
            evidence_latest.c.file_url.label("evidence_url"),
        )
        .join(User, Execution.capataz_id == User.id)
        .join(Point, Execution.point_id == Point.id)
        .join(Sector, Point.sector_id == Sector.id)
        .join(SubActivity, Point.subactivity_id == SubActivity.id)
        .outerjoin(evidence_latest, Execution.id == evidence_latest.c.execution_id)
        .filter(
            Execution.is_closed.is_(True),
            Execution.status.in_(["RESUELTO", "IMPOSIBILIDAD", "REPROGRAMACION"]),
            func.date(Execution.created_at) == export_date,
        )
        .all()
    )

    records = []
    for (
        execution,
        capataz_name,
        capataz_email,
        sector_name,
        district,
        locality,
        sgio,
        gis,
        suministro,
        direccion,
        subactivity_code,
        subactivity_name,
        evidence_url,
    ) in executions:
        records.append(
            {
                "capataz_name": capataz_name,
                "capataz_email": capataz_email,
                "sector": sector_name,
                "district": district,
                "locality": locality,
                "sgio": sgio,
                "gis": gis,
                "suministro": suministro,
                "direccion": direccion,
                "subactivity_code": subactivity_code,
                "subactivity_name": subactivity_name,
                "status": execution.status,
                "started_at": execution.started_at.isoformat() if execution.started_at else "",
                "ended_at": execution.ended_at.isoformat() if execution.ended_at else "",
                "duration_minutes": execution.duration_minutes,
                "evidence_url": evidence_url or "",
                "form_data": execution.form_data,
            }
        )

    if not records:
        return Response(status_code=status.HTTP_204_NO_CONTENT)

    export_root = Path(settings.export_root)
    export_dir = ensure_export_dir(export_root, export_date)

    grouped = group_by_subactivity(records)
    created_files: list[Path] = []
    for (subactivity_code, subactivity_name), items in grouped.items():
        if not items:
            continue
        headers = build_headers(subactivity_code)
        rows = build_rows(items, export_date, subactivity_code, subactivity_name)
        file_name = f"{subactivity_code}_{export_date.isoformat()}.xlsx"
        file_path = export_dir / file_name
        write_workbook(file_path, headers, rows)
        created_files.append(file_path)

    if not created_files:
        return Response(status_code=status.HTTP_204_NO_CONTENT)

    zip_path = export_dir / f"exports_{export_date.isoformat()}.zip"
    with ZipFile(zip_path, "w") as zip_file:
        for file_path in created_files:
            zip_file.write(file_path, arcname=file_path.name)

    return FileResponse(zip_path, media_type="application/zip", filename=zip_path.name)
