from logging.config import fileConfig

from sqlalchemy import engine_from_config, pool

from alembic import context

from app.core.config import settings
from app.db.base import Base
codex/initialize-project-scaffolding-for-fastapi-and-flutter-db7lmb
from app import models  # noqa: F401
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
from app import models  # noqa: F401
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
from app import models  # noqa: F401
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
from app import models  # noqa: F401
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
from app import models  # noqa: F401
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
from app import models  # noqa: F401
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
from app import models  # noqa: F401
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-drar0n
from app import models  # noqa: F401
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ra2stf
from app import models  # noqa: F401
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-70pu3t
from app import models  # noqa: F401
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-fxsc7m
from app import models  # noqa: F401
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-dvc5n3
from app import models  # noqa: F401
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-vry57d
from app import models  # noqa: F401
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-ugb2w8
from app import models  # noqa: F401
=======
from app.models import user  # noqa: F401
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
main
main

config = context.config
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

config.set_main_option("sqlalchemy.url", settings.database_url)

target_metadata = Base.metadata


def run_migrations_offline() -> None:
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    connectable = engine_from_config(
        config.get_section(config.config_ini_section),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        context.configure(connection=connection, target_metadata=target_metadata)

        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
