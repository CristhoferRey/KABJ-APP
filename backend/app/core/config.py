from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_prefix="KABJ_", env_file=".env", extra="ignore")

    database_url: str = "postgresql+psycopg2://kabj:kabj@db:5432/kabj"
    secret_key: str = "CHANGE_ME"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 60
codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
    admin_token: str = "CHANGE_ME_ADMIN"
    export_root: str = "backend/exports"
=======
 main


settings = Settings()
