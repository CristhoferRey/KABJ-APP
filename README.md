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
codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
docker compose exec backend alembic upgrade head
```
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
docker compose exec backend alembic upgrade head
```
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
docker compose exec backend alembic upgrade head
```
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
docker compose exec backend alembic upgrade head
```
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
docker compose exec backend alembic upgrade head
```
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
docker compose exec backend alembic upgrade head
```
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-drar0n
docker compose exec backend alembic upgrade head
```
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-ra2stf
docker compose exec backend alembic upgrade head
```
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-70pu3t
docker compose exec backend alembic upgrade head
```
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-fxsc7m
docker compose exec backend alembic upgrade head
```
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-dvc5n3
docker compose exec backend alembic upgrade head
```
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-vry57d
docker compose exec backend alembic upgrade head
```
=======
main
main
main
main
main
main
main
main
main
main
main

Para crear futuras migraciones:
```bash
docker compose exec backend alembic revision --autogenerate -m "descripcion"
```

codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
La aplicación FastAPI corre en `http://localhost:8000/health`.
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
La aplicación FastAPI corre en `http://localhost:8000/health`.
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
La aplicación FastAPI corre en `http://localhost:8000/health`.
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
La aplicación FastAPI corre en `http://localhost:8000/health`.
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
La aplicación FastAPI corre en `http://localhost:8000/health`.
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
La aplicación FastAPI corre en `http://localhost:8000/health`.
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-drar0n
La aplicación FastAPI corre en `http://localhost:8000/health`.
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ra2stf
La aplicación FastAPI corre en `http://localhost:8000/health`.
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-70pu3t
La aplicación FastAPI corre en `http://localhost:8000/health`.
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-fxsc7m
La aplicación FastAPI corre en `http://localhost:8000/health`.
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-dvc5n3
La aplicación FastAPI corre en `http://localhost:8000/health`.
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-vry57d
La aplicación FastAPI corre en `http://localhost:8000/health`.
=======
=======
docker compose exec backend alembic revision --autogenerate -m "init"
docker compose exec backend alembic upgrade head
```
main
main
main
main
main
main
main
main
main
main
main
main

## Mobile

La app móvil incluye una estructura inicial lista para crecimiento por features.

```bash
cd mobile
flutter run
```
codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-drar0n
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-ra2stf
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-70pu3t
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-fxsc7m
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-dvc5n3
main
main
main
main
main
main
main
main
main
main

## Evidencias (capturas)

Ejemplo para subir evidencia asociada a una ejecución:

```bash
curl -X POST "http://localhost:8000/mobile/evidence?execution_id=1" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "X-Device-Id: device-123" \
  -F "file=@/path/a/imagen.jpg"
```
codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
 main
 main
 main
main

## Export técnico diario (admin)

Genera un ZIP con un archivo XLSX por subactividad para la fecha indicada:

```bash
curl -X POST "http://localhost:8000/admin/export?date=2024-01-31" \
codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
  -H "Authorization: Bearer <ADMIN_TOKEN>" \
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
  -H "Authorization: Bearer <ADMIN_TOKEN>" \
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
  -H "Authorization: Bearer <ADMIN_TOKEN>" \
=======
  -H "X-Admin-Token: CHANGE_ME_ADMIN" \
main
main
main
  -o exports_2024-01-31.zip
```

Los archivos se guardan temporalmente en `backend/exports/YYYY-MM-DD/`.
codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
 main
main

### Crear admin inicial

```bash
export KABJ_ADMIN_EMAIL=admin@example.com
export KABJ_ADMIN_PASSWORD=secret123
export KABJ_ADMIN_NAME="Admin"
python backend/scripts/create_admin.py
```
codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
=======
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
=======
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-drar0n
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ra2stf
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-70pu3t
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-fxsc7m
=======
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-vry57d
=======

### Migraciones (alembic)

Dentro del contenedor backend:

```bash
docker compose exec backend alembic upgrade head

docker compose exec backend alembic revision --autogenerate -m "descripcion"
docker compose exec backend alembic upgrade head

main
main
main
main
main
main
main
main
main
main
 main
main
