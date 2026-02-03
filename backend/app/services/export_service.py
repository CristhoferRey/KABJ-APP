import json
from collections import defaultdict
from datetime import date
from pathlib import Path
from typing import Any

from openpyxl import Workbook



EXPORT_COLUMNS = [
    "date",
    "capataz_name",
    "capataz_email",
    "sector",
    "district",
    "locality",
    "sgio",
    "gis",
    "suministro",
    "direccion",
    "subactivity_code",
    "subactivity_name",
    "status",
    "started_at",
    "ended_at",
    "duration_minutes",
    "evidence_url",
    "form_data_json",
]


def ensure_export_dir(root: Path, export_date: date) -> Path:
    target_dir = root / export_date.isoformat()
    target_dir.mkdir(parents=True, exist_ok=True)
    if not target_dir.exists():
        raise RuntimeError("Failed to create export directory")
    return target_dir


def build_rows(
    records: list[dict[str, Any]],
    export_date: date,
    subactivity_code: str,
    subactivity_name: str,
) -> list[list[Any]]:
    rows: list[list[Any]] = []
    for record in records:
        base_row = [
            export_date.isoformat(),
            record["capataz_name"],
            record["capataz_email"],
            record["sector"],
            record["district"],
            record["locality"],
            record["sgio"],
            record["gis"],
            record["suministro"],
            record["direccion"],
            subactivity_code,
            subactivity_name,
            record["status"],
            record["started_at"],
            record["ended_at"],
            record["duration_minutes"],
            record["evidence_url"],
            json.dumps(record["form_data"], ensure_ascii=False) if record["form_data"] else "",
        ]

        extra_values: list[Any] = []
        if subactivity_code.upper() == "A1.37":
            form_data = record.get("form_data") or {}
            presion = form_data.get("presion")
            cloro = form_data.get("cloro")
            tiempo_min = record["duration_minutes"]
            extra_values.extend([presion, cloro, tiempo_min])
        elif subactivity_code.upper() == "C.3":
            form_data = record.get("form_data") or {}
            scheduled_day = form_data.get("scheduled_day") or form_data.get("day") or form_data.get("dia")
            observaciones = form_data.get("observaciones")
            extra_values.extend([scheduled_day, observaciones])

        rows.append(base_row + extra_values)
    return rows


def build_headers(subactivity_code: str) -> list[str]:
    headers = list(EXPORT_COLUMNS)
    if subactivity_code.upper() == "A1.37":
        headers.extend(["presion", "cloro", "tiempo_min"])
    elif subactivity_code.upper() == "C.3":
        headers.extend(["scheduled_day", "observaciones"])
    return headers


def write_workbook(path: Path, headers: list[str], rows: list[list[Any]]) -> None:
    workbook = Workbook()
    sheet = workbook.active
    sheet.append(headers)
    for row in rows:
        sheet.append(row)
    workbook.save(path)


def group_by_subactivity(records: list[dict[str, Any]]) -> dict[tuple[str, str], list[dict[str, Any]]]:
    grouped: dict[tuple[str, str], list[dict[str, Any]]] = defaultdict(list)
    for record in records:
        key = (record["subactivity_code"], record["subactivity_name"])
        grouped[key].append(record)
    return grouped

