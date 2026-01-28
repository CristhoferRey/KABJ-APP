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
codex/initialize-project-scaffolding-for-fastapi-and-flutter-vry57d
docker compose exec backend alembic upgrade head
```
=======
main

Para crear futuras migraciones:
```bash
docker compose exec backend alembic revision --autogenerate -m "descripcion"
```

codex/initialize-project-scaffolding-for-fastapi-and-flutter-vry57d
La aplicación FastAPI corre en `http://localhost:8000/health`.
=======
=======
docker compose exec backend alembic revision --autogenerate -m "init"
docker compose exec backend alembic upgrade head
```
main

## Mobile

La app móvil incluye una estructura inicial lista para crecimiento por features.

```bash
cd mobile
flutter run
```
codex/initialize-project-scaffolding-for-fastapi-and-flutter-vry57d
=======

### Migraciones (alembic)

Dentro del contenedor backend:

```bash
docker compose exec backend alembic upgrade head

docker compose exec backend alembic revision --autogenerate -m "descripcion"
docker compose exec backend alembic upgrade head

main
