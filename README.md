# KABJ App

Scaffolding inicial para backend (FastAPI + PostgreSQL/PostGIS) y mobile (Flutter).

## Backend

### Requisitos
- Docker / Docker Compose

### Levantar servicios
```bash
docker compose up --build
```

### Migraciones (alembic)
Dentro del contenedor backend:
```bash
docker compose exec backend alembic upgrade head
```

Para crear futuras migraciones:
```bash
docker compose exec backend alembic revision --autogenerate -m "descripcion"
```

La aplicación FastAPI corre en `http://localhost:8000/health`.

## Mobile

La app móvil incluye una estructura inicial lista para crecimiento por features.

```bash
cd mobile
flutter run
```

## Evidencias (capturas)

Ejemplo para subir evidencia asociada a una ejecución:

```bash
curl -X POST "http://localhost:8000/mobile/evidence?execution_id=1" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "X-Device-Id: device-123" \
  -F "file=@/path/a/imagen.jpg"
```

## Export técnico diario (admin)

Genera un ZIP con un archivo XLSX por subactividad para la fecha indicada:

```bash
curl -X POST "http://localhost:8000/admin/export?date=2024-01-31" \
  -H "Authorization: Bearer <ADMIN_TOKEN>" \
  -o exports_2024-01-31.zip
```

Los archivos se guardan temporalmente en `backend/exports/YYYY-MM-DD/`.

### Crear admin inicial

```bash
export KABJ_ADMIN_EMAIL=admin@example.com
export KABJ_ADMIN_PASSWORD=secret123
export KABJ_ADMIN_NAME="Admin"
python backend/scripts/create_admin.py
```
