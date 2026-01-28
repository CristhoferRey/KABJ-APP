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

Para crear futuras migraciones:
```bash
docker compose exec backend alembic revision --autogenerate -m "descripcion"
```

=======
docker compose exec backend alembic revision --autogenerate -m "init"
docker compose exec backend alembic upgrade head
```

## Mobile

La app móvil incluye una estructura inicial lista para crecimiento por features.

```bash
cd mobile
flutter run
```

### Migraciones (alembic)

Dentro del contenedor backend:

```bash
docker compose exec backend alembic upgrade head

docker compose exec backend alembic revision --autogenerate -m "descripcion"
docker compose exec backend alembic upgrade head

