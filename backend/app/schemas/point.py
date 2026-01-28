from pydantic import BaseModel


class PointResponse(BaseModel):
    id: int
    subactivity_id: int
    sector_id: int
    sgio: str | None = None
    gis: str | None = None
    suministro: str | None = None
    direccion: str | None = None
    locality: str | None = None
    district: str | None = None
    is_active: bool
    lat: float
    lng: float
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-70pu3t
    needs_evidence: bool = False
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-fxsc7m
    needs_evidence: bool = False
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-dvc5n3
    needs_evidence: bool = False
=======
main
 main
 main
