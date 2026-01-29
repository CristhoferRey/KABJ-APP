 codex/initialize-project-scaffolding-for-fastapi-and-flutter-db7lmb
import csv
import io
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
import csv
import io
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
import csv
import io
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
import csv
import io
=======
 main
 main
main
 main
from datetime import date as date_type
from pathlib import Path
from zipfile import ZipFile

 codex/initialize-project-scaffolding-for-fastapi-and-flutter-db7lmb
from fastapi import APIRouter, Depends, HTTPException, Query, Response, UploadFile, status
from fastapi.responses import FileResponse
from geoalchemy2 import WKTElement
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
from fastapi import APIRouter, Depends, HTTPException, Query, Response, UploadFile, status
from fastapi.responses import FileResponse
from geoalchemy2 import WKTElement
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
from fastapi import APIRouter, Depends, HTTPException, Query, Response, UploadFile, status
from fastapi.responses import FileResponse
from geoalchemy2 import WKTElement
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
from fastapi import APIRouter, Depends, HTTPException, Query, Response, UploadFile, status
from fastapi.responses import FileResponse
from geoalchemy2 import WKTElement
=======
from fastapi import APIRouter, Depends, HTTPException, Query, Response, status
from fastapi.responses import FileResponse
main
 main
 main
 main
from sqlalchemy import and_, func
from sqlalchemy.orm import Session

from app.core.config import settings
from app.core.deps import require_admin
from app.db.session import get_db
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-db7lmb
from app.models.assignment import Assignment
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
from app.models.assignment import Assignment
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
from app.models.assignment import Assignment
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
from app.models.assignment import Assignment
=======
main
 main
 main
 main
from app.models.evidence import Evidence
from app.models.execution import Execution
from app.models.point import Point
from app.models.sector import Sector
from app.models.subactivity import SubActivity
from app.models.user import User
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-db7lmb
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
 main
 main
 main
from app.schemas.admin import (
    AssignmentCreate,
    AssignmentRead,
    ImportRowError,
    ImportSummary,
    ImportSummaryDetailed,
    PointCreate,
    PointRead,
    SectorCreate,
    SectorRead,
    SubActivityRead,
)
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-db7lmb
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
=======
=======
 main
 main
 main
 main
from app.services.export_service import (
    build_headers,
    build_rows,
    ensure_export_dir,
    group_by_subactivity,
    write_workbook,
)

router = APIRouter(prefix="/admin")


 codex/initialize-project-scaffolding-for-fastapi-and-flutter-db7lmb
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
 main
 main
 main
@router.get("/sectors", response_model=list[SectorRead])
def list_sectors(db: Session = Depends(get_db), _: User = Depends(require_admin)) -> list[SectorRead]:
    return db.query(Sector).all()


@router.post("/sectors", response_model=SectorRead, status_code=status.HTTP_201_CREATED)
def create_sector(
    payload: SectorCreate,
    db: Session = Depends(get_db),
    _: User = Depends(require_admin),
) -> SectorRead:
    sector = Sector(name=payload.name, district=payload.district, locality=payload.locality)
    db.add(sector)
    db.commit()
    db.refresh(sector)
    return sector


@router.get("/subactivities", response_model=list[SubActivityRead])
def list_subactivities(
    db: Session = Depends(get_db),
    _: User = Depends(require_admin),
) -> list[SubActivityRead]:
    return db.query(SubActivity).all()


@router.get("/points", response_model=list[PointRead])
def list_points(
    sector_id: int | None = None,
    subactivity_id: int | None = None,
    db: Session = Depends(get_db),
    _: User = Depends(require_admin),
) -> list[PointRead]:
    query = db.query(
        Point,
        func.ST_Y(Point.geom).label("lat"),
        func.ST_X(Point.geom).label("lng"),
    )
    if sector_id is not None:
        query = query.filter(Point.sector_id == sector_id)
    if subactivity_id is not None:
        query = query.filter(Point.subactivity_id == subactivity_id)

    results: list[PointRead] = []
    for point, lat, lng in query.all():
        results.append(
            PointRead(
                id=point.id,
                subactivity_id=point.subactivity_id,
                sector_id=point.sector_id,
                sgio=point.sgio,
                gis=point.gis,
                suministro=point.suministro,
                direccion=point.direccion,
                locality=point.locality,
                district=point.district,
                lat=lat,
                lng=lng,
                is_active=point.is_active,
            )
        )
    return results


@router.post("/points", response_model=PointRead, status_code=status.HTTP_201_CREATED)
def create_point(
    payload: PointCreate,
    db: Session = Depends(get_db),
    _: User = Depends(require_admin),
) -> PointRead:
    if not (-90 <= payload.lat <= 90 and -180 <= payload.lng <= 180):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid lat/lng")
    geom = WKTElement(f"POINT({payload.lng} {payload.lat})", srid=4326)
    point = Point(
        subactivity_id=payload.subactivity_id,
        sector_id=payload.sector_id,
        sgio=payload.sgio,
        gis=payload.gis,
        suministro=payload.suministro,
        direccion=payload.direccion,
        locality=payload.locality,
        district=payload.district,
        geom=geom,
        is_active=True,
    )
    db.add(point)
    db.commit()
    db.refresh(point)
    return PointRead(
        id=point.id,
        subactivity_id=point.subactivity_id,
        sector_id=point.sector_id,
        sgio=point.sgio,
        gis=point.gis,
        suministro=point.suministro,
        direccion=point.direccion,
        locality=point.locality,
        district=point.district,
        lat=payload.lat,
        lng=payload.lng,
        is_active=point.is_active,
    )


@router.post("/points/import", response_model=ImportSummary)
def import_points(
    file: UploadFile,
    db: Session = Depends(get_db),
    _: User = Depends(require_admin),
) -> ImportSummary:
    content = file.file.read().decode("utf-8")
    reader = csv.DictReader(io.StringIO(content))

    created = 0
    skipped = 0
    errors: list[ImportRowError] = []

    for index, row in enumerate(reader, start=2):
        try:
            subactivity_code = (row.get("subactivity_code") or "").strip()
            sector_name = (row.get("sector_name") or "").strip()
            district = (row.get("district") or "").strip()
            locality = (row.get("locality") or "").strip()
            lat_raw = row.get("lat")
            lng_raw = row.get("lng")

            if not subactivity_code or not sector_name:
                skipped += 1
                errors.append(ImportRowError(row=index, message="Missing subactivity_code or sector_name"))
                continue

            subactivity = (
                db.query(SubActivity)
                .filter(func.upper(SubActivity.code) == subactivity_code.upper())
                .first()
            )
            if not subactivity:
                skipped += 1
                errors.append(ImportRowError(row=index, message="Subactivity not found"))
                continue

            if lat_raw is None or lng_raw is None:
                skipped += 1
                errors.append(ImportRowError(row=index, message="Missing lat/lng"))
                continue

            lat = float(lat_raw)
            lng = float(lng_raw)
            if not (-90 <= lat <= 90 and -180 <= lng <= 180):
                skipped += 1
                errors.append(ImportRowError(row=index, message="Invalid lat/lng"))
                continue

            sector = (
                db.query(Sector)
                .filter(
                    Sector.name == sector_name,
                    Sector.district == district,
                    Sector.locality == locality,
                )
                .first()
            )
            if not sector:
                sector = Sector(name=sector_name, district=district, locality=locality)
                db.add(sector)
                db.flush()

            geom = WKTElement(f"POINT({lng} {lat})", srid=4326)
            point = Point(
                subactivity_id=subactivity.id,
                sector_id=sector.id,
                sgio=(row.get("sgio") or "").strip() or None,
                gis=(row.get("gis") or "").strip() or None,
                suministro=(row.get("suministro") or "").strip() or None,
                direccion=(row.get("direccion") or "").strip() or None,
                locality=locality or None,
                district=district or None,
                geom=geom,
                is_active=True,
            )
            db.add(point)
            created += 1
        except Exception as exc:  # noqa: BLE001
            skipped += 1
            errors.append(ImportRowError(row=index, message=str(exc)))

    db.commit()
    summary = ImportSummaryDetailed(created=created, skipped=skipped, errors=errors)
    return summary.to_summary()


@router.get("/assignments", response_model=list[AssignmentRead])
def list_assignments(
    date: date_type | None = Query(None),
    db: Session = Depends(get_db),
    _: User = Depends(require_admin),
) -> list[AssignmentRead]:
    query = db.query(Assignment).filter(Assignment.is_active.is_(True))
    if date is not None:
        query = query.filter(Assignment.date_from <= date, Assignment.date_to >= date)
    return query.all()


@router.post("/assignments", response_model=AssignmentRead, status_code=status.HTTP_201_CREATED)
def create_assignment(
    payload: AssignmentCreate,
    db: Session = Depends(get_db),
    _: User = Depends(require_admin),
) -> AssignmentRead:
    if payload.date_from > payload.date_to:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid date range")

    assignment = Assignment(
        subactivity_id=payload.subactivity_id,
        sector_id=payload.sector_id,
        capataz_id=payload.capataz_id,
        date_from=payload.date_from,
        date_to=payload.date_to,
        is_active=True,
    )
    db.add(assignment)
    db.commit()
    db.refresh(assignment)
    return assignment


@router.delete("/assignments/{assignment_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_assignment(
    assignment_id: int,
    db: Session = Depends(get_db),
    _: User = Depends(require_admin),
) -> Response:
    assignment = db.query(Assignment).filter(Assignment.id == assignment_id).first()
    if not assignment:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Assignment not found")
    assignment.is_active = False
    db.add(assignment)
    db.commit()
    return Response(status_code=status.HTTP_204_NO_CONTENT)


 codex/initialize-project-scaffolding-for-fastapi-and-flutter-db7lmb
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
=======
=======
main
main
 main
 main
@router.post("/export")
def export_daily(
    export_date: date_type = Query(..., alias="date"),
    db: Session = Depends(get_db),
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-db7lmb
    _: User = Depends(require_admin),
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
    _: User = Depends(require_admin),
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
    _: User = Depends(require_admin),
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
    _: User = Depends(require_admin),
=======
    _: str = Depends(require_admin),
main
main
 main
 main
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
